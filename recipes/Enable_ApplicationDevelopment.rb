

powershell_script 'Enable Application Development' do
    code 'Add-WindowsFeature Web-App-Dev'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-App-Dev" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Application Development installed successfully"

powershell_script 'Enable .Net Extensibility' do
    code 'Add-WindowsFeature Web-Net-Ext'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-Net-Ext" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::.Net Extensibility enabled"


powershell_script 'Enable .Net Extensibility 4.5' do
    code 'Add-WindowsFeature Web-Net-Ext45'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-Net-Ext45" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::.Net Extensibility v4.5 enabled"

powershell_script 'Enable ASP.Net 3.5' do
    code 'Add-WindowsFeature Web-Asp-Net'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-Asp-Net" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::ASP.Net 3.5 enabled"

powershell_script 'Enable ASP.Net 4.5' do
    code 'Add-WindowsFeature Web-Asp-Net45'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-Asp-Net45" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::ASP.Net 4.5 enabled"

powershell_script 'Enable ISAPI Extensions' do
    code 'Add-WindowsFeature Web-ISAPI-Ext'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-ISAPI-Ext" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::ISAPI Extensions enabled"

powershell_script 'Enable ISAPI Filters' do
    code 'Add-WindowsFeature Web-ISAPI-Filter'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-ISAPI-Filter" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::ISAPI Filters enabled"

powershell_script 'Enable WebSocket Protocol' do
    code 'Add-WindowsFeature Web-WebSockets'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-WebSockets" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::WebSocket Protocol enabled"
