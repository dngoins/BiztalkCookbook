powershell_script 'Disable Firewall' do
    code 'Set-NetFirewallProfile -Profile domain,public,private -enabled false'
    guard_interpreter   :powershell_script
    not_if  '(get-netfirewallprofile -profile domain,public,private).enabled -eq true'
end