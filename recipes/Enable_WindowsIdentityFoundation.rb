powershell_script 'Enable Windows Identity Foundation v3.5' do
    code 'Install-WindowsFeature -Name "Windows-Identity-Foundation" -IncludeAllSubFeature'
    guard_interpreter   :powershell_script
    not_if  '(Get-WindowsFeature | where {$_.Name -eq "Windows-Identity-Foundation"}).IsInstalled -eq true'
end