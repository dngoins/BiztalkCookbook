powershell_script 'Enable Application Server' do
    code 'Add-WindowsFeature Application-Server'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature ) | where { $_.Name -eq "Application-Server" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::.Application Server installed successfully"

powershell_script 'Enable Application Server .Net Framework 4.5 Features' do
    code 'Add-WindowsFeature AS-NET-Framework'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "AS-NET-Framework" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Application Server .Net Framework 4.5 installed successfully"

powershell_script 'Enable Application Server Distributed Transactions' do
    code 'Add-WindowsFeature AS-Dist-Transaction'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "AS-Dist-Transaction" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Application Server Distributed Transactions installed"


powershell_script 'Enable .Net Framework 4.5 Core' do
    code 'Add-WindowsFeature NET-Framework-45-Core'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "NET-Framework-45-Core" }).InstallState -eq "Installed" '
end

powershell_script 'Enable .Net Framework 4.5 Features' do
    code 'Add-WindowsFeature NET-Framework-45-Features'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "NET-Framework-45-Features" }).InstallState -eq "Installed" '
end

powershell_script 'Enable .Net Framework 4.5 ASP.NET Core' do
    code 'Add-WindowsFeature NET-Framework-45-ASPNET'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "NET-Framework-45-ASPNET" }).InstallState -eq "Installed" '
end