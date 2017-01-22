
powershell_script 'Configure Application Event Log for BizTalk Servers' do
    code 'Limit-EventLog -LogName "Application" -MaximumSize 40MB -Overflow Overwriteasneeded'
    guard_interpreter   :powershell_script
    not_if  '(Get-EventLog -list | where {$_.Log -eq "Application"}).MaximumKilobytes -eq 40960'
    not_if  '(Get-EventLog -list | where {$_.Log -eq "Application"}).OverflowAction -eq "OverwriteAsNeeded"'
end


powershell_script 'Clear Application Event Log' do
    code 'Clear-EventLog -Log "Application"'
    guard_interpreter   :powershell_script
    not_if  '((Get-EventLog -list | where {$_.Log -eq "Application"}).Entries | measure).count -eq 0'
    
end