powershell_script 'Enable Message Queuing' do
    code 'Add-WindowsFeature MSMQ'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature ) | where { $_.Name -eq "MSMQ" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Message Queuing enabled successfully"


powershell_script 'Enable Message Queuing Services' do
    code 'Add-WindowsFeature MSMQ-Services'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature ) | where { $_.Name -eq "MSMQ-Services" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Message Queuing Services enabled successfully"

powershell_script 'Enable Message Queuing Services HTTP Support' do
    code 'Add-WindowsFeature MSMQ-Http-Support'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature ) | where { $_.Name -eq "MSMQ-Http-Support" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Message Queuing Services Http Support enabled successfully"
