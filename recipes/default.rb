#
# Cookbook Name:: BiztalkCookbook
# Recipe:: default
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

s3_file 'c:\setup\bts\DeploymentFrameworkForBizTalkV5_6.msi' do
    remote_path "/DeploymentFrameworkForBizTalkV5_6.msi"
    bucket node['BiztalkCookbook']['aws_s3_bucket']
    aws_access_key_id node['BiztalkCookbook']['aws_access_key_id']
    aws_secret_access_key node['BiztalkCookbook']['aws_secret_access_key']
    s3_url "https://s3.amazonaws.com/goins.chefsoftware"
    owner node['BiztalkCookbook']['aws_owner']
    action :create    
end
 log "#{cookbook_name}::DeploymentFrameworkFor Biztalk Msi downloaded from Artifactory to C:\\setup\\bts\\DeploymentFrameworkForBizTalkV5_6.msi successfully"


s3_file 'c:\setup\bts\SqlXml4.msi' do
    remote_path "/SqlXml4.msi"
    bucket node['BiztalkCookbook']['aws_s3_bucket']
    aws_access_key_id node['BiztalkCookbook']['aws_access_key_id']
    aws_secret_access_key node['BiztalkCookbook']['aws_secret_access_key']
    s3_url "https://s3.amazonaws.com/goins.chefsoftware"
    owner node['BiztalkCookbook']['aws_owner']
    action :create    
end
log "#{cookbook_name}::SQL Xml version 4.0 msi from artifactory downloaded to C:\\setup\\bts\\SqlXml4.msi successfully"

s3_file 'c:\setup\bts\BTS.iso' do
    remote_path "/en_biztalk_server_2016_developer_x64_dvd_9520931.iso"
    bucket node['BiztalkCookbook']['aws_s3_bucket']
    aws_access_key_id node['BiztalkCookbook']['aws_access_key_id']
    aws_secret_access_key node['BiztalkCookbook']['aws_secret_access_key']
    s3_url "https://s3.amazonaws.com/goins.chefsoftware"
    owner node['BiztalkCookbook']['aws_owner']
    action :create    
end
log "#{cookbook_name}:: BizTalk Setup ISO File downloaded from Artifactory Server as C:\\setup\\bts\\BTS.iso successfully"

template 'c:\setup\bts\BizTalkServerFeatures.xml' do
    source 'BizTalkFeaturesServer.erb'    
end
log "#{cookbook_name}::BizTalk Features File from template copied to C:\\setup\\bts\\BizTalkServerFeatures.xml successfully"

s3_file 'c:\setup\bts\BTSRedistW2k12R2EN64.cab' do
    remote_path "/BTSRedistW2k12R2EN64.cab"
    bucket node['BiztalkCookbook']['aws_s3_bucket']
    aws_access_key_id node['BiztalkCookbook']['aws_access_key_id']
    aws_secret_access_key node['BiztalkCookbook']['aws_secret_access_key']
    s3_url "https://s3.amazonaws.com/goins.chefsoftware"
    owner node['BiztalkCookbook']['aws_owner']
    action :create    
end
log "#{cookbook_name}::BizTalk Dependency Cab File downloaded from Artifactory Server as C:\\setup\\bts\\BTSRedistW2k12R2EN64.cab successfully"

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

cookbook_file "c:\\setup\\bts\\BizTalkFactoryPowershell.msi" do
  source "BizTalkFactory.PowerShell.Extensions.Setup - v1.4.0.1.msi" 
  action :create_if_missing
  #file name in in ur files dir
end
log "#{cookbook_name}::BizTalk BizTalk Factory Powershell Extensions downloaded"

package 'BizTalk Factory Powershell Extensions Installation' do
  action :install
  source 'c:\setup\bts\BizTalkFactoryPowerShell.msi'
end

case node['BiztalkCookbook']['DefaultConfig']
when 'Server'
  include_recipe "#{cookbook_name}::Install_BizTalk"
when 'Build'
  include_recipe "#{cookbook_name}::Install_BizTalk_BuildServer"
when 'LocalDev'
  include_recipe "#{cookbook_name}::Install_BizTalk_LocalDevServer"
when 'Test'
  include_recipe "#{cookbook_name}::Install_BizTalk_TestServer"
end

# using packages the msi returns 1 which is considered an error but it isn't in this case'
# msiexec /qn /i "c:\setup\bts\deploymentframeworkforbiztalkv5_6.msi

package 'DeploymentFramework' do
  action :install
  source 'c:\setup\bts\DeploymentFrameworkForBizTalkV5_6.msi'
end


case node['BiztalkCookbook']['DefaultConfig']
when 'LocalDev'
  include_recipe "#{cookbook_name}::configure_LocalBizTalk"
  include_recipe "#{cookbook_name}::Configure_CustomHosts"
  include_recipe "#{cookbook_name}::Install_CustomApplications"  
when 'Test'
  include_recipe "#{cookbook_name}::configure_TestBizTalk"
  include_recipe "#{cookbook_name}::Configure_CustomHosts"
  include_recipe "#{cookbook_name}::Install_CustomApplications"  
end


