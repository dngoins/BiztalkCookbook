#
# Cookbook Name:: BiztalkCookbook
# Recipe:: configure_TestBizTalk Server
#
# Copyright (C) 2017  Dwight Goins
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# requires the BiztalkCookbook::Install_BizTalk_TestServer recipe to be run first

# in a test environment we figure to have a separate SQL Server
# That SQL needs to push it's fqdn to the URL listed below as a text file'
# this remote resource will download the file and the following powershell simply
# reads the file name
remote_file 'c:\setup\sql\DynamicServerName.txt' do
  source node['BiztalkCookbook']['SQL_DynamicInstanceName']
 action :create_if_missing
end
log "#{cookbook_name}::Dynamic SQL Server Name to c:\\setup\\sql successfully"

powershell_script 'Configure Test BizTalk Instance' do
  code <<-EOH  

        $userName = "#{node['BiztalkCookbook']['BTS_SvcHostAccount']}"
        $isoUserName = "#{node['BiztalkCookbook']['BTS_SvcIsoHostAccount']}"
        $userPassword = "#{node['BiztalkCookbook']['BTS_SvcHostAccountPassword']}"
        $isoUserPassword = "#{node['BiztalkCookbook']['BTS_SvcIsoHostAccountPassword']}"
        $configFile = "#{node['BiztalkCookbook']['BTS_ServerFeaturesFile']}"

        write-host "Getting SQL Server Name from file"
        $sqlName = [System.IO.File]::ReadAllText("c:\\setup\\sql\\DynamicServerName.txt")
        $featuresFileContent = [System.IO.File]::ReadAllText($configFile)
       
        write-host "Replacing SQL Server Name: $sqlName in features File"
        $updatedContent = $featuresFileContent.Replace("<Server>.</Server>", "<Server>$sqlName</Server>")        
        [System.IO.File]::WriteAllText($configFile, $updatedContent)

        write-host "Adding user:  $userName  to local administrators group"
        NET USER $userName $userPassword /ADD
        NET LOCALGROUP "administrators" $userName /ADD

        NET USER $isoUserName $isoUserPassword /ADD
        NET LOCALGROUP "administrators" $isoUserName /ADD

        cd "C:\\Program Files (x86)\\Microsoft BizTalk Server 2013 R2"
        $argList = "/s " + $configFile + " /l c:\\setup\\bts\\configuration.log /noprogressbar"

        write-host "Starting BizTalk Configuration..."
        start-Process -filePath ".\\configuration.exe" -argumentList "/s c:\\setup\\bts\\biztalkserverfeatures.xml /l c:\\setup\\bts\\configuration.log /noprogressbar" -wait
        
        write-host "BizTalk Configuration complete"
    EOH
    guard_interpreter   :powershell_script
  # not_if '( (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\BizTalk Server\3.0").ProductVersion -eq "3.11.158.0") '
    not_if '((Get-ItemProperty "hklm:SOFTWARE\\Microsoft\\Biztalk Server\\3.0\\Administration").MgmtDBName -neq $null)'
end
log "#{cookbook_name}::BizTalk 2013 R2 Test Server Configured"




template 'c:\setup\bts\ESBConfigurationTool.exe.config' do
  source 'esbconfigurationtool.exe.config.erb'
  action :create_if_missing
end

powershell_script 'Configure TEST BizTalk ESB Toolkit' do
  code <<-EOH  

          
        move-item -path "C:\\Program Files (x86)\\Microsoft BizTalk ESB Toolkit\\Bin\\ESBConfigurationTool.exe.config" -destination "C:\\Program Files (x86)\\Microsoft BizTalk ESB Toolkit\\Bin\\ESBConfigurationTool.exe.config.old"  
        
         write-host "Updating ESB Configuration Tool with correct SQL Server"
        write-host "Getting SQL Server Name from file"
        $configFile = "C:\\setup\\bts\\ESBConfigurationTool.exe.config"
        $sqlName = [System.IO.File]::ReadAllText("c:\\setup\\sql\\DynamicServerName.txt")
        $featuresFileContent = [System.IO.File]::ReadAllText($configFile)

        write-host "Replacing SQL Server Name: $sqlName in features File"
        $updatedContent = $featuresFileContent.Replace("@sqlserver", "$sqlName")
        [System.IO.File]::WriteAllText($configFile, $updatedContent)
        
        copy-item -path "C:\\setup\\bts\\ESBConfigurationTool.exe.config" -destination "C:\\Program Files (x86)\\Microsoft BizTalk ESB Toolkit\\Bin\\ESBConfigurationTool.exe.config"
      
    EOH
  #   guard_interpreter   :powershell_script
  # # not_if '( (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\BizTalk Server\3.0").ProductVersion -eq "3.11.158.0") '
  #   not_if '((Get-ItemProperty "hklm:SOFTWARE\\Microsoft\\Biztalk Server\\3.0\\Administration").MgmtDBName -neq $null)'
end
log "#{cookbook_name}::BizTalk 2013 R2 TEST ESB Toolkit Configured"
