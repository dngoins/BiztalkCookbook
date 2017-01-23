#
# Cookbook Name:: BiztalkCookbook
# Recipe:: Install_CustomApplications
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

# requires the BiztalkCookbook::Configure_FinSuiteHosts recipe to be run first

# example of where to download custom msi's from BizTalk Deployment Framework'
# directory 'c:\setup\bts\CustomAps' do
#   action :create
#   recursive true  
# end
# log "#{cookbook_name}::Directory custom app folder Created successfully"


cookbook_file "c:\\setup\\bts\\Install_BizTalkApplications.ps1" do
  source "Install_BizTalkApplications.ps1" 
  action :create_if_missing
  #file name in in ur files dir
end
log "#{cookbook_name}::BizTalk InstallBizTalkApplications Silently Powershell script downloaded"


# remote_file 'c:\setup\bts\CustomApps\CustomApp-1.0.0.0.msi' do
#   source node['BiztalkCookbook']['CustomApp-1.0.0.0.msi']
#  action :create_if_missing  
# end


# log "#{cookbook_name}::Installing CustomApp-1.0.0.0.msi"
#  package 'CustomApp-1.0.0.0.msi Installation' do
#    action :install
#    source 'c:\setup\bts\CustomApps\CustomApp-1.0.0.0.msi'
#  end
# log "#{cookbook_name}::CustomApp-1.0.0.0.msi Installed Successfully"


# powershell_script 'Register Custom Applications In BizTalk' do
#   code <<-EOH  

#           write-host "Setting Execution policy for the current session"
#           Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -force

#           write-host "Registering Core v1.0.0.0"
#           cd "C:\\Program Files (x86)\\CustomApp\\1.0.0.0\\Deployment"
#           copy-item -path "C:\\setup\\bts\\Install_BizTalkApplications.ps1" -destination "Install_BizTalkApplications.ps1"
#           copy-item -path "c:\\setup\\bts\\CustomApps\\CustomApp-1.0.0.0.msi" -destination "C:\\Program Files (x86)\\CustomApp\\1.0.0.0\\Deployment\\CustomApp-1.0.0.0.msi"
#           .\\Install_BizTalkApplications.ps1 -MsiFile "CustomApp-1.0.0.0.msi" -ApplicationInstallPath "C:\\Program Files (x86)\\CustomApp\\1.0.0.0" -DeploymentFile CustomApp.deployment.btdfproj -Environment DEV


#    [System.IO.File]::WriteAllText("c:\\setup\\bts\\_chefCustomApps.lock", "complete")
        
#     EOH
#  guard_interpreter   :powershell_script
#    not_if '([System.IO.File]::exists("c:\\setup\\bts\\_chefCustomApps.lock")'

# end
log "#{cookbook_name}::Custom Applications Registered"

