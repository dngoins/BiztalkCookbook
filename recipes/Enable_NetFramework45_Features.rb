powershell_script 'Enable .Net Framework 4.5 Features' do
    code 'Add-WindowsFeature NET-Framework-45-Features'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "NET-Framework-45-Features" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::.Net Framework 4.5 Features installed successfully"

powershell_script 'Enable .Net Framework 4.5 Features Core' do
    code 'Add-WindowsFeature NET-Framework-45-Core'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "NET-Framework-45-Core" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::.Net Framework 4.5 Features Core installed successfully"

powershell_script 'Enable .Net Framework 4.5 Features ASP.NET 4.5' do
    code 'Add-WindowsFeature NET-Framework-45-ASPNET'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "NET-Framework-45-ASPNET" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::.Net Framework 4.5 Features ASP.NET 4.5 installed successfully"

powershell_script 'Enable .Net Framework 4.5 Features WCF Services' do
    code 'Add-WindowsFeature NET-WCF-Services45'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "NET-WCF-Services45" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::.Net Framework 4.5 Features WCF Services installed successfully"


powershell_script 'Enable .Net Framework 4.5 Features WCF Services HTTP Activation' do
    code 'Add-WindowsFeature NET-WCF-HTTP-Activation45'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "NET-WCF-HTTP-Activation45" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::.Net Framework 4.5 Features WCF Services HTTP Activation installed successfully"


powershell_script 'Enable .Net Framework 4.5 Features WCF Services MSMQ Activation' do
    code 'Add-WindowsFeature NET-WCF-MSMQ-Activation45'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "NET-WCF-MSMQ-Activation45" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::.Net Framework 4.5 Features WCF Services MSMQ Activation installed successfully"


powershell_script 'Enable .Net Framework 4.5 Features WCF Services Pipe Activation' do
    code 'Add-WindowsFeature NET-WCF-Pipe-Activation45'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "NET-WCF-Pipe-Activation45" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::.Net Framework 4.5 Features WCF Services Pipe Activation installed successfully"


powershell_script 'Enable .Net Framework 4.5 Features WCF Services TCP Activation' do
    code 'Add-WindowsFeature NET-WCF-TCP-Activation45'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "NET-WCF-TCP-Activation45" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::.Net Framework 4.5 Features WCF Services TCP Activation installed successfully"


powershell_script 'Enable .Net Framework 4.5 Features WCF Services TCP PortSharing' do
    code 'Add-WindowsFeature NET-WCF-TCP-PortSharing45'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "NET-WCF-TCP-PortSharing45" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::.Net Framework 4.5 Features WCF Services TCP PortSharing installed successfully"



