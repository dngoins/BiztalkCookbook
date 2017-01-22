

powershell_script 'Enable .Net Framework 2.0 Features' do
    code 'Add-WindowsFeature NET-Framework-Features'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "NET-Framework-Features" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::.Net Framework 2.0 Features installed successfully"

powershell_script 'Enable .Net Framework 2.0 Core' do
    code 'Add-WindowsFeature NET-Framework-Core'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "NET-Framework-Core" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::.Net Framework 2.0 Core installed successfully (Requirement for SQLXML v4.0)"


powershell_script 'Enable .Net Framework 3.5 Features HTTP Activation' do
    code 'Add-WindowsFeature NET-HTTP-Activation'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "NET-HTTP-Activation" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::.Net Framework 3.5 HTTP Activation installed successfully (Requirement for SQLXML v4.0)"