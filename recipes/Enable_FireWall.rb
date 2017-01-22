powershell_script 'Enable Firewall' do
    code 'Set-NetFirewallProfile -Profile domain,public,private -enable true'
    guard_interpreter   :powershell_script
    not_if  '(get-netfirewallprofile -profile domain,public,private).enable -eq false'
end