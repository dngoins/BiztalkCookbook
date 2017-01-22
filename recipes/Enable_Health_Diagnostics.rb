

powershell_script 'Enable Health and Diagnostics' do
    code 'Add-WindowsFeature Web-Health'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-Health" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Web Health and Diagnostics installed successfully"

powershell_script 'Enable Web HTTP Logging' do
    code 'Add-WindowsFeature Web-Http-Logging'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-Http-Logging" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Web  Http Logging enabled"


powershell_script 'Enable Web Custom Logging' do
    code 'Add-WindowsFeature Web-Custom-Logging'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-Custom-Logging" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Web Custom Logging enabled"

powershell_script 'Enable Web ODBC Logging' do
    code 'Add-WindowsFeature Web-ODBC-Logging'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-ODBC-Logging" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Web ODBC Logging enabled"

powershell_script 'Enable Web Request Monitor' do
    code 'Add-WindowsFeature Web-Request-Monitor'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-Request-Monitor" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Web Request Monitor enabled"

powershell_script 'Enable Web HTTP Tracing' do
    code 'Add-WindowsFeature Web-Http-Tracing'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-Http-Tracing" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Web Http Tracing enabled"

