

powershell_script 'Enable Http Redirect' do
    code 'Add-WindowsFeature Web-Http-Redirect'
    guard_interpreter   :powershell_script
    not_if  '((get-windowsfeature  ) | where { $_.Name -eq "Web-Http-Redirect" }).InstallState -eq "Installed" '
end
log "#{cookbook_name}::Http Redirect enabled"
