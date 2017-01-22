

powershell_script 'Enable Security' do
    code 'Add-WindowsFeature Web-Security'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-Security" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Web Security installed successfully"

powershell_script 'Enable Web Security Request Filtering' do
    code 'Add-WindowsFeature Web-Filtering'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-Filtering" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Web Security Request Filtering enabled"


powershell_script 'Enable Web Security Basic Authentication' do
    code 'Add-WindowsFeature Web-Basic-Auth'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-Basic-Auth" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Web Security Basic Authentication enabled"

powershell_script 'Enable Web Security Client Certificate Mapping Authentication' do
    code 'Add-WindowsFeature Web-Client-Auth'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-Client-Auth" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Web Security Client Certificate Mapping Authentication enabled"

powershell_script 'Enable Web Security Digest Authentication' do
    code 'Add-WindowsFeature Web-Digest-Auth'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-Digest-Auth" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Web Security Digest Authentication enabled"

powershell_script 'Enable Web Security Windows Authentication' do
    code 'Add-WindowsFeature Web-Windows-Auth'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-Windows-Auth" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Web Security Windows Authentication enabled"

