#
# Cookbook Name:: THOTH_SPEED_BIZTALK
# Recipe:: Install_BizTalk_Server / Integration / Stage/ QA/ Production
#
# Copyright (C) 2016  Dwight Goins
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

directory  'c:\Setup\Bts' do
    recursive true
    action :create
end
log "#{cookbook_name}::Directory c:\\Setup\\BTS Created successfully"


# remote_file 'c:\setup\bts\DeploymentFrameworkForBizTalkV5_6.msi' do
#    source node['BIZTALK']['BTS_ISOUrl'] 
#    action :create
#  end
# log "#{cookbook_name}::DeploymentFrameworkFor Biztalk Msi downloaded from Artifactory to C:\\setup\\bts\\DeploymentFrameworkForBizTalkV5_6.msi successfully"

remote_file 'c:\setup\bts\SqlXml4.msi' do
   source "https://dl.bintray.com/thothspeedengineers/chef_software/sqlxml_x64.msi?expiry=1478871017247&id=GQnrx0kQs4akfNENK7i1vhcxvN6x3HpQg84DEaPJiyviBc9jqq7k%2B%2FmyYyCIDRMGXWEeXROJWcwb4Y%2Fo%2FlN1iw%3D%3D&signature=SqM6CQJt%2BXVgcoxGXe2%2FqR%2Fuip71PzUYSl7Cg9kkSiFzsvyxTXUuqXvaONBmq%2Bwjr0HTHPv1cwKKoOHNZtHYWQ%3D%3D"
   action :create
 end
log "#{cookbook_name}::SQL Xml version 4.0 msi from artifactory downloaded to C:\\setup\\bts\\SqlXml4.msi successfully"

remote_file 'c:\setup\bts\BTS.iso' do
    source "https://dl.bintray.com/thothspeedengineers/chef_software/bts.iso?expiry=1478873146750&id=GQnrx0kQs4akfNENK7i1vhcxvN6x3HpQg84DEaPJiyviBc9jqq7k%2B%2FmyYyCIDRMGXWEeXROJWcwb4Y%2Fo%2FlN1iw%3D%3D&signature=MhsS%2FyQFd5SCdXWUxJGO616SsfOb84dbCK%2BC197gX6xrBtBMHruJC8O4J9XDP%2B%2Bx%2BJRVj99xKNTfNWc6RaILig%3D%3D"
    action :create
end
log "#{cookbook_name}:: BizTalk Setup ISO File downloaded from Artifactory Server as C:\\setup\\bts\\BTS.iso successfully"

template 'c:\setup\bts\BizTalkServerFeatures.xml' do
    source 'BizTalkFeaturesServer.erb'    
end
log "#{cookbook_name}::BizTalk Features File from template copied to C:\\setup\\bts\\BizTalkServerFeatures.xml successfully"


remote_file 'c:\setup\bts\BTSRedistW2k12R2EN64.cab' do
    source "https://dl.bintray.com/thothspeedengineers/chef_software/BtsRedistW2K12R2EN64.cab?expiry=1478870917050&id=GQnrx0kQs4akfNENK7i1vhcxvN6x3HpQg84DEaPJiyviBc9jqq7k%2B%2FmyYyCIDRMGXWEeXROJWcwb4Y%2Fo%2FlN1iw%3D%3D&signature=X5waKOtnPIV1H%2FTlPwZ%2BnUSdwBiRHXAx1mZSED2EaVVcC%2BPB7yPIB6TNoVKMwERY%2BbzPF4WYthZQ0nWHqfNxlg%3D%3D"
    action :create
end
log "#{cookbook_name}::BizTalk Dependency Cab File downloaded from Artifactory Server as C:\\setup\\bts\\BTSRedistW2k12R2EN64.cab successfully"

# remote_file 'c:\setup\bts\WinSCP.exe' do
#     source "https://dl.bintray.com/thothspeedengineers/chef_software/WinSCP-5.9.2-Setup.exe?expiry=1478786460493&id=GQnrx0kQs4akfNENK7i1vhcxvN6x3HpQg84DEaPJiyviBc9jqq7k%2B%2FmyYyCIDRMGXWEeXROJWcwb4Y%2Fo%2FlN1iw%3D%3D&signature=dp5bB9p2mNoJhUk4ZUputOuuXOcMfluGADzHOJsL5OOOdMMsvPQztd88OwgEO049c6IGpY1QqPl5taA5QEymnA%3D%3D"
#     action :create
# end
# log "#{cookbook_name}::WinSCP for SFTP downloaded from Artifactory Server as C:\\setup\\bts\\WinSCP.exe successfully"


include_recipe "#{cookbook_name}::Enable_IIS"
log "#{cookbook_name}::Enabled IIS"

include_recipe "#{cookbook_name}::Enable_HttpRedirect"
log "#{cookbook_name}::Enabled HttpRedirect"

include_recipe "#{cookbook_name}::Enable_Web_Security"
log "#{cookbook_name}::Enabled Web Security"

include_recipe "#{cookbook_name}::Enable_Health_Diagnostics"
log "#{cookbook_name}::Enabled Health and Diagnostics"

include_recipe "#{cookbook_name}::Enable_WindowsIdentityFoundation"
log "#{cookbook_name}::Enabled Windows Identity Foundation"

include_recipe "#{cookbook_name}::Disable_IPv6"
log "#{cookbook_name}::DisableIPv6 successfully"

include_recipe "#{cookbook_name}::Disable_IE_Enhanced_Security"
log "#{cookbook_name}::Disabled IE Enhanced Security Successfully"

include_recipe "#{cookbook_name}::Disable_UAC"
log "#{cookbook_name}::Disabled UAC successfully"

include_recipe "#{cookbook_name}::Disable_FireWall"
log "#{cookbook_name}::Disabled Firewall Successfully"

include_recipe "#{cookbook_name}::ConfigureApplicationEventLog"
log "#{cookbook_name}::Configured Application Event Log Successfully"

include_recipe "#{cookbook_name}::Enable_ApplicationDevelopment"
log "#{cookbook_name}::Enabled Application Development features"

include_recipe "#{cookbook_name}::Enable_NetFramework45_Features"
log "#{cookbook_name}::Enabled .Net 4.5 framework features"

include_recipe "#{cookbook_name}::Enable_ASPNet45"
log "#{cookbook_name}::Enabled ASP.Net 4.5 framework"

include_recipe "#{cookbook_name}::Enable_NetFramework20"
log "#{cookbook_name}::Enabled .Net Framework 2.0 and 3.5"

include_recipe "#{cookbook_name}::Enable_IIS6_Mgmt_Compatibility"
log "#{cookbook_name}::Enabled IIS 6.0 Management Compatibility"

include_recipe "#{cookbook_name}::Enable_Windows_Process_Activation_Service"
log "#{cookbook_name}::Enabled Windows Process Activation Service successfully"

include_recipe "#{cookbook_name}::Enable_TelnetClient"
log "#{cookbook_name}::Enabled Telnet Client successfully"

include_recipe "#{cookbook_name}::Enable_MessageQueuing"
log "#{cookbook_name}::Enabled Message Queuing successfully"
 

windows_package 'SQL Xml v4.0' do
    action :install
    source 'c:\setup\bts\SQLXml4.msi'
end
log "#{cookbook_name}::SQL Xml version 4.0 was installed"

log "#{cookbook_name}::Starting BizTalk Core Component Setup..."
log "#{cookbook_name}::Starting BizTalk Core Component Setup..."

powershell_script 'Install BizTalk Core Components' do
  code <<-EOH
        $btsIsoFile = "c:\\setup\\bts\\BTS.Iso"
        $btsMountResult = (Mount-DiskImage $btsIsoFile -PassThru)
    $btsDriveLetter = ($btsMountResult | Get-Volume).Driveletter
    $btsDrive = $btsDriveLetter + ":"
    cd $btsDrive
    cd "\\BizTalk Server\\Platform\\sso64\\platform\\VCRedist\\x64"
   start-Process -filePath ".\\vcredist.exe" -argumentList "/q" -wait

    cd "\\BizTalk Server\\Platform\\sso64\\platform\\vcredist\\x86"
   start-Process -filePath ".\\vcredist.exe" -argumentList "/q" -wait

    cd "\\BizTalk Server\\Platform\\SSO64"
    start-process -filePath ".\\setup.exe" -argumentList "/quiet /ADDLOCAL ALL /L c:\\setup\\bts\\SSOLog.txt" -wait

    cd "\\BizTalk Server"
    
    start-Process -filePath ".\\setup.exe" -argumentList "/s c:\\setup\\bts\\biztalkserverfeatures.xml /L c:\\setup\\bts\\install.log /CABPATH c:\\setup\\bts\\BTSRedistW2k12R2EN64.cab"  -wait

    dismount-diskimage $btsIsoFile
    EOH
  guard_interpreter :powershell_script
  not_if '( (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\BizTalk Server\3.0").ProductVersion -eq "3.11.158.0") '
  #  not_if '(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\BizTalk Server\3.0")'
end

log "#{cookbook_name}::Installed BizTalk CoreComponents Successfully"

# using packages the msi returns 1 which is considered an error but it isn't in this case'
# msiexec /qn /i "c:\setup\bts\deploymentframeworkforbiztalkv5_6.msi

#  package 'DeploymentFramework' do
#      action :install
#      source 'c:\setup\bts\DeploymentFrameworkForBizTalkV5_6.msi'
#  end

