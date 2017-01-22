#
# Cookbook Name:: BiztalkCookbook
# Recipe:: Install_BizTalk_BuildServer / Development machine
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

directory 'c:\Setup\VS' do
    recursive true
    action :create
end
log "#{cookbook_name}::VS Directory c:\\setup\\vs Created successfully"

remote_file 'c:\setup\vs\en_visual_studio_ultimate_2013_with_update_5_x86_dvd_6815896.iso' do
    source node['BiztalkCookbook']['VS2013_IsoUrl']
    action :create
end
log "#{cookbook_name}::VS Iso downloaded from Artifactory to c:\\setup\\vs successfully"

template 'c:\setup\vs\AdminDeployment.xml' do
    source 'AdminDeployment.erb'    
end
log "#{cookbook_name}::VS.Net AdminDeployment C:\\setup\\vs\\AdminDeployment.xml successfully"


remote_file 'c:\setup\bts\DeploymentFrameworkForBizTalkV5_6.msi' do
   source node['BiztalkCookbook']['BTS_DeploymentFrameworkMsiUrl']
   action :create
 end
log "#{cookbook_name}::DeploymentFrameworkFor Biztalk Msi downloaded from Artifactory to C:\\setup\\bts\\DeploymentFrameworkForBizTalkV5_6.msi successfully"

remote_file 'c:\setup\bts\SqlXml4.msi' do
   source node['BiztalkCookbook']['SQLXmlUrl']
   action :create
 end
log "#{cookbook_name}::SQL Xml version 4.0 msi from artifactory downloaded to C:\\setup\\bts\\SqlXml4.msi successfully"

remote_file 'c:\setup\bts\BTS.iso' do
    source node['BiztalkCookbook']['BTS_ISOUrl']
    action :create
end
log "#{cookbook_name}:: BizTalk Setup ISO File downloaded from Artifactory Server as C:\\setup\\bts\\BTS.iso successfully"

template 'c:\setup\bts\BizTalkFeatures.xml' do
    source 'BizTalkFeaturesBuildServer.erb'    
end
log "#{cookbook_name}::BizTalk Features File from template copied to C:\\setup\\bts\\BizTalkFeatures.xml successfully"


remote_file 'c:\setup\bts\BTSRedistW2k12EN64.cab' do
    source node['BiztalkCookbook']['BTS_DependencyCabUrl']
    action :create
end
log "#{cookbook_name}::BizTalk Dependency Cab File downloaded from Artifactory Server as C:\\setup\\bts\\BTSRedistW2k8EN64.cab successfully"



include_recipe 'THOTH_SPEED_iis_core::default'
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
 

package 'SQL Xml v4.0' do
    action :install
    source 'c:\setup\bts\SQLXml4.msi'
end
log "#{cookbook_name}::SQL Xml version 4.0 was installed"

powershell_script 'Install Visual Studio 2013 Ultimate Update 5' do
    code <<-EOH         
        $vsIsoFile = "#{node.default['BiztalkCookbook']['VS_ISOFile']}"
        $vsMountResult = (Mount-DiskImage $vsIsoFile -PassThru)      
    $vsDriveLetter = ($vsMountResult | Get-Volume).Driveletter
    $vsDrive = $vsDriveLetter + ":"
    cd $vsDrive    
    $vsLaunchProcess = ".\\vs_ultimate.exe" 
    start-Process -filePath ".\\vs_ultimate.exe" -argumentList "/adminfile c:\\setup\\vs\\admindeployment.xml /quiet /norestart /L c:\\setup\\vs\\install.log" -wait
    dismount-diskimage $vsIsoFile   
    EOH
 
end
log "#{cookbook_name}::Installed VS.Net 2013 Ultimate with Update 5 Successfully"

log "#{cookbook_name}::Starting BizTalk Core Component Setup..."
powershell_script 'Install BizTalk Core Components' do
    code <<-EOH         
        $btsIsoFile = "#{node['BiztalkCookbook']['BTS_ISOFile']}"
        $btsCabFile = "#{node['BiztalkCookbook']['BTS_DependencyCab']}"
        $btsFeaturesFile = "#{node['BiztalkCookbook']['BTS_FeaturesFile']}"
        $btsErrorLog = "#{node['BiztalkCookbook']['BTS_LogFile']}"
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
    $btsArgs = "/s '" + $btsFeaturesFile + "' /L '" + $btsErrorLog + "' /CABPATH '" + $btsCabFile + "'"        
    start-Process -filePath ".\\setup.exe" -argumentList "/s c:\\setup\\bts\\biztalkfeatures.xml /L c:\\setup\\bts\\install.log /CABPATH c:\\setup\\bts\\BTSRedistW2k12EN64.cab"  -wait
    
    dismount-diskimage $btsIsoFile
    EOH
    guard_interpreter   :powershell_script
    not_if '( (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\BizTalk Server\3.0").ProductVersion -eq "3.11.158.0") '
  #  not_if '(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\BizTalk Server\3.0")'
end
log "#{cookbook_name}::Installed BizTalk CoreComponents Successfully"

# using packages the msi returns 1 which is considered an error but it isn't in this case'
# msiexec /qn /i "c:\setup\bts\deploymentframeworkforbiztalkv5_6.msi

 package 'DeploymentFramework' do
     action :install
     source 'c:\setup\bts\DeploymentFrameworkForBizTalkV5_6.msi'
 end

