powershell_script 'Disable UAC' do
    code 'Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\system" -Name "EnableLUA" -value 0'
    guard_interpreter   :powershell_script
    not_if  '(Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\system").EnableLUA -eq 0'    
end