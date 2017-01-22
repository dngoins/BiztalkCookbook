powershell_script 'Enable Process Activation Service' do
    code 'Add-WindowsFeature WAS'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature ) | where { $_.Name -eq "WAS" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Windows Process Activation Service enabled successfully"

powershell_script 'Enable Process Model' do
    code 'Add-WindowsFeature WAS-Process-Model'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "WAS-Process-Model" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Process Model enabled successfully"

powershell_script 'Enable .Net Environment 3.5' do
    code 'Add-WindowsFeature WAS-NET-Environment'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "WAS-NET-Environment" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::.Net Environment 3.5 enabled successfully"


powershell_script 'Enable Configuration APIs' do
    code 'Add-WindowsFeature WAS-Config-APIs'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "WAS-Config-APIs" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Configuration APIs successfully enabled"

