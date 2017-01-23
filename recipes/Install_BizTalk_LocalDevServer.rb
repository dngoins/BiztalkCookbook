#
# Cookbook Name:: BiztalkCookbook
# Recipe:: Install_BizTalk_LocalDev Server
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
# curl -u myUser:myP455w0rd! -X PUT "http://localhost:8081/artifactory/my-repository/my/new/artifact/directory/file.txt" -T Desktop/myNewFile.txt
# requires the BiztalkCookbook::Default recipe to be run first

include_recipe "#{cookbook_name}::InstallSql_AllFeatures"

# directory 'c:\Setup\VS' do
#   recursive true
#   action :create
# end

log "#{cookbook_name}::VS Directory c:\\setup\\vs Created successfully"

# remote_file 'c:\setup\vs\en_visual_studio_ultimate_2013_with_update_5_x86_dvd_6815896.iso' do
#   source node['BiztalkCookbook']['VS2013_IsoUrl']
#  action :create_if_missing
  
# end
# log "#{cookbook_name}::VS Iso downloaded from Artifactory to c:\\setup\\vs successfully"

# template 'c:\setup\vs\AdminDeployment.xml' do
#   source 'VSInstallConfig.erb'
#   action :create_if_missing
# end
# log "#{cookbook_name}::VS.Net AdminDeployment C:\\setup\\vs\\AdminDeployment.xml successfully"


# powershell_script 'Install Visual Studio 2013 Ultimate Update 5' do
#   code <<-EOH
#         $vsIsoFile = "#{node.default['BiztalkCookbook']['VS_ISOFile']}"
#         $vsMountResult = (Mount-DiskImage $vsIsoFile -PassThru)
#     $vsDriveLetter = ($vsMountResult | Get-Volume).Driveletter
#     $vsDrive = $vsDriveLetter + ":"
#     cd $vsDrive
#     $vsLaunchProcess = ".\\vs_ultimate.exe"
#     start-Process -filePath ".\\vs_ultimate.exe" -argumentList "/adminfile c:\\setup\\vs\\admindeployment.xml /quiet /norestart /L c:\\setup\\vs\\install.log" -wait
#     dismount-diskimage $vsIsoFile
#     EOH
#   guard_interpreter :powershell_script
#   not_if '[System.IO.File]::Exists("C:\\Program Files (x86)\\Microsoft Visual Studio 12.0\\Common7\\IDE\\devenv.exe")'
# end
# log "#{cookbook_name}::Installed VS.Net 2013 Ultimate with Update 5 Successfully"

# log "#{cookbook_name}::Starting BizTalk Core Component Setup..."
# powershell_script 'Install BizTalk Core Components' do
#   code <<-EOH
#         $btsIsoFile = "#{node['BiztalkCookbook']['BTS_ISOFile']}"
#         $btsCabFile = "#{node['BiztalkCookbook']['BTS_DependencyCab']}"
#         $btsFeaturesFile = "#{node['BiztalkCookbook']['BTS_LocalDevFeaturesFile']}"
#         $btsErrorLog = "#{node['BiztalkCookbook']['BTS_LogFile']}"
#         $btsMountResult = (Mount-DiskImage $btsIsoFile -PassThru)
#     $btsDriveLetter = ($btsMountResult | Get-Volume).Driveletter
#     $btsDrive = $btsDriveLetter + ":"
#     cd $btsDrive
#     cd "\\BizTalk Server\\Platform\\sso64\\platform\\VCRedist\\x64"
#    start-Process -filePath ".\\vcredist.exe" -argumentList "/q" -wait

#     cd "\\BizTalk Server\\Platform\\sso64\\platform\\vcredist\\x86"
#    start-Process -filePath ".\\vcredist.exe" -argumentList "/q" -wait

#     cd "\\BizTalk Server\\Platform\\SSO64"
#     start-process -filePath ".\\setup.exe" -argumentList "/quiet /ADDLOCAL ALL /L c:\\setup\\bts\\SSOLog.txt" -wait

#     cd "\\BizTalk Server"
#     $btsArgs = "/s '" + $btsFeaturesFile + "' /L '" + $btsErrorLog + "' /CABPATH '" + $btsCabFile + "'"
#     start-Process -filePath ".\\setup.exe" -argumentList "/s c:\\setup\\bts\\biztalkbuildfeatures.xml /L c:\\setup\\bts\\install.log /CABPATH c:\\setup\\bts\\BTSRedistW2k12EN64.cab"  -wait

#     write-host "Installing ESB Toolkit 2.3"
#     cd "ESBT_x64"
#     start-Process -filePath "c:\\windows\\sysWow64\\msiexec.exe" -argumentList "/qn /le ""C:\\setup\\bts\\esbLog.log"" /i ""Biztalk ESB Toolkit 2.3.msi"" "  -wait

#     dismount-diskimage $btsIsoFile
#     EOH
#   guard_interpreter :powershell_script
#   not_if '( (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\BizTalk Server\3.0").ProductVersion -eq "3.11.158.0") '
# end
log "#{cookbook_name}::Installed BizTalk Server Core & Dev Components Successfully"
