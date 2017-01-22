powershell_script 'Enable Telnet Client' do
    code 'Add-WindowsFeature Telnet-Client'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature ) | where { $_.Name -eq "Telnet-Client" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Telnet Client enabled successfully"
