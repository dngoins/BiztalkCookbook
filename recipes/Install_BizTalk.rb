#
# Cookbook Name:: BiztalkCookbook
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

    write-host "Installing ESB Toolkit 2.3"
    cd "ESBT_x64"
    start-Process -filePath "c:\\windows\\sysWow64\\msiexec.exe" -argumentList "/qn /le ""C:\\setup\\bts\\esbLog.log"" /i ""Biztalk ESB Toolkit 2.3.msi"" "  -wait

    dismount-diskimage $btsIsoFile
    EOH
  guard_interpreter :powershell_script
  not_if '( (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\BizTalk Server\3.0").ProductVersion -eq "3.11.158.0") '

end

log "#{cookbook_name}::Installed BizTalk CoreComponents Successfully"

