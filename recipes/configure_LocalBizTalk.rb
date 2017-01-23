#
# Cookbook Name:: BiztalkCookbook
# Recipe:: configure_LocalBizTalk Server
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

# requires the BiztalkCookbook::Install_BizTalk_LocalDevServer recipe to be run first

powershell_script 'Configure Local BizTalk Instance' do
  code <<-EOH  
        $userName = "#{node['BiztalkCookbook']['BTS_LocalSvcHostAccount']}"
        $userPassword = "#{node['BiztalkCookbook']['BTS_LocalSvcHostAccountPassword']}"
        $isoUserName = "#{node['BiztalkCookbook']['BTS_LocalSvcIsoHostAccount']}"
        $isoUserPassword = "#{node['BiztalkCookbook']['BTS_LocalSvcIsoHostAccountPassword']}"

        write-host "Using : " + $userName + " as Service Host Account to configure BizTalk"        
        $configFile = "#{node['BiztalkCookbook']['BTS_LocalDevFeaturesFile']}"
        NET USER $userName $userPassword /ADD
        NET LOCALGROUP "administrators" $userName /ADD

        NET USER $isoUserName $isoUserPassword /ADD
        NET LOCALGROUP "administrators" $isoUserName /ADD

        write-host "Added " + $userName + " to Local Administrators group "
        
        write-host "Getting SQL Server Name from file"
        $sqlName = $env:COMPUTERNAME
        $featuresFileContent = [System.IO.File]::ReadAllText($configFile)
       
        write-host "Replacing SQL Server Name: " + $sqlName + " in features File"
        $_Content = $featuresFileContent.Replace("<Server>.</Server>", "<Server>$sqlName</Server>")
        $updatedContent = $_Content.Replace("<Domain>.</Domain>", "<Domain></Domain>")
        [System.IO.File]::WriteAllText($configFile, $updatedContent)

        cd "C:\\Program Files (x86)\\Microsoft BizTalk Server 2013 R2"
        $argList = "/s " + $configFile + " /l c:\\setup\\bts\\configuration.log /noprogressbar"
        start-Process -filePath ".\\configuration.exe" -argumentList "/s c:\\setup\\bts\\BizTalkLocalDevFeatures.xml /l c:\\setup\\bts\\configuration.log /noprogressbar" -wait
        
    EOH
    guard_interpreter   :powershell_script
    not_if '((Get-ItemProperty "hklm:SOFTWARE\\Microsoft\\Biztalk Server\\3.0\\Administration").MgmtDBName -neq $null)'
end
log "#{cookbook_name}::BizTalk 2013 R2 Configured"



template 'c:\setup\bts\ESBConfigurationTool.exe.config' do
  source 'local.esbconfigurationtool.exe.config.erb'
  action :create_if_missing
end

powershell_script 'Configure BizTalk ESB Toolkit' do
  code <<-EOH  

       # start-Process -filePath "C:\\Program Files (x86)\\Microsoft Visual Studio 12.0\\Common7\\IDE\\VSIXInstaller.exe" -argumentList """C:\\Program Files (x86)\\Microsoft BizTalk ESB Toolkit\\Tools\\Itinerary Designer\\Microsoft.Practices.Services.Itinerary.DslPackage.vsix"" /q /s:Ultimate /v:12.0" -wait        
       
        move-item -path "C:\\Program Files (x86)\\Microsoft BizTalk ESB Toolkit\\Bin\\ESBConfigurationTool.exe.config" -destination "C:\\Program Files (x86)\\Microsoft BizTalk ESB Toolkit\\Bin\\ESBConfigurationTool.exe.config.old" -force 
                
        write-host "Updating ESB Configuration Tool with correct SQL Server"
        write-host "Getting SQL Server Name from file"
        $configFile = "C:\\setup\\bts\\ESBConfigurationTool.exe.config"
        $sqlName = $env:COMPUTERNAME
        $featuresFileContent = [System.IO.File]::ReadAllText($configFile)

        write-host "Replacing SQL Server Name: $sqlName in features File"
        $updatedContent = $featuresFileContent.Replace("@sqlserver", "$sqlName")
        [System.IO.File]::WriteAllText($configFile, $updatedContent)

        copy-item -path "C:\\setup\\bts\\ESBConfigurationTool.exe.config" -destination "C:\\Program Files (x86)\\Microsoft BizTalk ESB Toolkit\\Bin\\ESBConfigurationTool.exe.config" -force
      
    EOH
 
end
log "#{cookbook_name}::BizTalk 2013 R2 ESB Toolkit Configured - You must run the GUI to complete"
