powershell_script 'Enable IIS 6.0 Mgmt Compatibility' do
    code 'Add-WindowsFeature Web-Mgmt-Compat'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature) | where { $_.Name -eq "Web-Mgmt-Compat" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::IIS 6.0 Mgmt Compatibility Enabled"

powershell_script 'Enable IIS 6.0 Metabase Compatibility' do
    code 'Add-WindowsFeature Web-Metabase'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature) | where { $_.Name -eq "Web-Metabase" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::IIS 6.0 Metabase Compatibility Enabled"


powershell_script 'Enable IIS 6.0 Management Console' do
    code 'Add-WindowsFeature Web-Lgcy-Mgmt-Console'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature ) | where { $_.Name -eq "Web-Lgcy-Mgmt-Console" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::IIS 6.0 Mgmt Console Enabled"



powershell_script 'Enable IIS 6.0 Scrpting Tools' do
    code 'Add-WindowsFeature Web-Lgcy-Scripting'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature ) | where { $_.Name -eq "Web-Lgcy-Scripting" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::IIS 6.0 Scripting Tools"


powershell_script 'Enable IIS 6.0 WMI Compatibility' do
    code 'Add-WindowsFeature Web-WMI'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature ) | where { $_.Name -eq "Web-WMI" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::IIS 6.0 WMI Compatibility"


powershell_script 'Enable IIS 6.0 Mgmt Scripts and Tools' do
    code 'Add-WindowsFeature Web-Scripting-Tools'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature ) | where { $_.Name -eq "Web-Scripting-Tools" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::IIS 6.0 Mgmt Scripts and Tools"


powershell_script 'Enable IIS 6.0 Mgmt Services' do
    code 'Add-WindowsFeature Web-Mgmt-Service'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature ) | where { $_.Name -eq "Web-Mgmt-Service" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::IIS 6.0 Mgmt Services"

