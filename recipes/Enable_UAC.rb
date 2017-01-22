powershell_script 'Enable UAC' do
    code 'Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\system" -Name "EnableLUA" -Value 1'
    guard_interpreter   :powershell_script
    not_if  '(Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\system").EnableLUA -eq 1'
end