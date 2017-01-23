#
# Cookbook Name:: BiztalkCookbook
# Recipe:: configure_customHosts
#
# Copyright (C) 2017  Dwight Goins
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# requires the BiztalkCookbook::Install_BizTalk_LocalDevServer recipe to be run first

#download remote file https://psbiztalk.codeplex.com/downloads/get/919078
 
# set the TransformThreshold
# registry_key 'HKEY_LOCAL_MACHINE\Software\Microsoft\BizTalk Server\3.0\Administration' do
#   values [{
#     :name => "TransformThreshold",
#     :type => :dword,
#     :data => 33554432
#   }]
#   action :create_if_missing
# end

# configure the BizTalkGroupSettings
# template 'c:\setup\bts\BizTalkGroupSettings.xml' do
#   source 'BizTalkGroupSettings.erb'
#   action :create_if_missing
# end
# log "#{cookbook_name}::BizTalk Group Settings File from template copied to C:\\setup\\bts\\BizTalkGroupSettings.xml successfully"

# Configure ESB Bindings
# template 'c:\setup\bts\Microsoft.Practices.Esb.Bindings.xml' do
#   source 'microsoft.practices.esb.bindings.erb'
#   action :create_if_missing
# end
# log "#{cookbook_name}::Microsoft Practices ESB Binding File from template copied to C:\\setup\\bts\\Microsoft.Practices.Esb.Binding.xml successfully"

# Use the PowerShell Provider BizTalk Snap-in to configure Hosts
# powershell_script 'Configure FinSuite Hosts' do
#    architecture :i386
# code <<-EOH  
  
# Write-host "Getting BizMgmtDb Server Name"
# $btsConnectionString = "server=.;database=BizTalkMgmtDb;Integrated Security=SSPI;"
# $btsDBServer =  (Get-ItemProperty "hklm:SOFTWARE\\Microsoft\\Biztalk Server\\3.0\\Administration").MgmtDBServer
# $btsMgmtDB =  (Get-ItemProperty "hklm:SOFTWARE\\Microsoft\\Biztalk Server\\3.0\\Administration").MgmtDBName
# $btsConnectionString = "server="+$btsDBServer+";database="+$btsMgmtDB+";Integrated Security=SSPI"
  
# Write-Host "Loading Powershell provider for BizTalk snap-in"
  
# $InitializeDefaultBTSDrive = $false
# Add-PSSnapin -Name BizTalkFactory.Powershell.Extensions
  
# Write-Host $btsDBServer
  
# New-PSDrive -Name BizTalk -Root BizTalk:\\ -PsProvider BizTalk -Instance $btsDBServer -Database $btsMgmtDB
  
# Write-Host "Switch to the default BizTalk drive"
# Set-Location -Path BizTalk:
  
# Write-Host "Importing BizTalk Group Settings"
# Import-GroupSettings -Path BizTalk:\\ -Source c:\\setup\\bts\\BizTalkGroupSettings.xml

# Write-Host "Start Checking BizTalk Hosts"
# Set-Location -Path "Platform Settings\\Hosts"
 
# Write-host "Getting Default BizTalk Applicaton Users Group Name"
# $btsApplicationGroupName = Get-ItemProperty -Path 'BizTalkServerApplication' -Name 'NtGroupName'
# $btsIsolatedHostGroupName = Get-ItemProperty -Path 'BizTalkServerIsolatedHost' -Name 'NtGroupName'
  
# write-host "Check if RcvAdapterHost Host Exists"
# $RcvAdapterHost = Get-ChildItem | Where-Object{$_.Name -eq "RcvAdapterHost"}
# if($RcvAdapterHost.Name -eq $null)
# {
#        Write-Host "Creating RcvAdapter Hosts"
#        New-Item RcvAdapterHost  -NtGroupName $btsApplicationGroupName.NtGroupName -HostType 'InProcess'
#        Set-ItemProperty -Path RcvAdapterHost -Name 'Is32BitOnly' -Value 'False'
# }
  

# write-host "Check if SndAdapterHost Host Exists"
# $SndAdapterHost = Get-ChildItem | Where-Object{$_.Name -eq "SndAdapterHost"}
# if($SndAdapterHost.Name -eq $null)
# {
#        Write-Host "Creating SndAdapter Hosts"
#        New-Item SndAdapterHost  -NtGroupName $btsApplicationGroupName.NtGroupName -HostType 'InProcess'
#        Set-ItemProperty -Path SndAdapterHost -Name 'Is32BitOnly' -Value 'False'
# }
  
#   write-host "Check if OrchHost Host Exists"
# $OrchHost = Get-ChildItem | Where-Object{$_.Name -eq "OrchHost"}
# if($OrchHost.Name -eq $null)
# {
#        Write-Host "Creating Orch Hosts"
#        New-Item OrchHost  -NtGroupName $btsApplicationGroupName.NtGroupName -HostType 'InProcess'
#        Set-ItemProperty -Path OrchHost -Name 'Is32BitOnly' -Value 'False'
# }

# write-host "Check if Rcv32AdapterHost Host Exists"
# $Rcv32AdapterHost = Get-ChildItem | Where-Object{$_.Name -eq "Rcv32AdapterHost"}
# if($Rcv32AdapterHost.Name -eq $null)
# {
#        Write-Host "Creating Rcv32Adapter Hosts"
#        New-Item Rcv32AdapterHost  -NtGroupName $btsApplicationGroupName.NtGroupName -HostType 'InProcess'
#        Set-ItemProperty -Path Rcv32AdapterHost -Name 'Is32BitOnly' -Value 'True'
# }
  


# write-host "Check if 32OrchHost Host Exists"
# $32OrchHost = Get-ChildItem | Where-Object{$_.Name -eq "32OrchHost"}
# if($32OrchHost.Name -eq $null)
# {
#        Write-Host "Creating 32Orch Hosts"
#        New-Item 32OrchHost  -NtGroupName $btsApplicationGroupName.NtGroupName -HostType 'InProcess'
#        Set-ItemProperty -Path 32OrchHost -Name 'Is32BitOnly' -Value 'True'
# }

# write-host "Check if LargeDataHost Host Exists"
# $LargeDataHost = Get-ChildItem | Where-Object{$_.Name -eq "LargeDataHost"}
# if($LargeDataHost.Name -eq $null)
# {
#        Write-Host "Creating 32Orch Hosts"
#        New-Item LargeDataHost  -NtGroupName $btsApplicationGroupName.NtGroupName -HostType 'InProcess'
#        Set-ItemProperty -Path LargeDataHost -Name 'Is32BitOnly' -Value 'False'
#        Set-ItemProperty -Path LargeDataHost -Name 'ProcessMemoryThreshold' -Value '75'
# }

# write-host "Check if 32LargeDataHost Host Exists"
# $32LargeDataHost = Get-ChildItem | Where-Object{$_.Name -eq "32LargeDataHost"}
# if($32LargeDataHost.Name -eq $null)
# {
#        Write-Host "Creating 32Orch Hosts"
#        New-Item 32LargeDataHost  -NtGroupName $btsApplicationGroupName.NtGroupName -HostType 'InProcess'
#        Set-ItemProperty -Path 32LargeDataHost -Name 'Is32BitOnly' -Value 'True'
#        Set-ItemProperty -Path 32LargeDataHost -Name 'ProcessMemoryThreshold' -Value '75'
# }
  
  
# write-host "Check if Snd32AdapterHost Host Exists"
# $Snd32AdapterHost = Get-ChildItem | Where-Object{$_.Name -eq "Snd32AdapterHost"}
# if($Snd32AdapterHost.Name -eq $null)
# {
#        Write-Host "Creating 32Orch Hosts"
#        New-Item Snd32AdapterHost  -NtGroupName $btsApplicationGroupName.NtGroupName -HostType 'InProcess'
#        Set-ItemProperty -Path Snd32AdapterHost -Name 'Is32BitOnly' -Value 'True'
#        Set-ItemProperty -Path Snd32AdapterHost -Name 'ProcessMemoryThreshold' -Value '75'
# }
  
#   $BTSDefault = Get-ChildItem | Where-Object{$_.Name -eq "BizTalkServerApplicaiton"}
# if($BTSDefault.Name -ne $null)
# {
#        Write-Host "Updating BizTalk Server Application Hosts"
#        Set-ItemProperty -Path BizTalkServerApplication -Name 'ThreadPoolSize' -Value '50'       
# }
  

# Write-Host "End Checking BizTalk Hosts"

#    [System.IO.File]::WriteAllText("c:\\setup\\bts\\_chefCustomHostConfigured.lock", "complete")
        
#     EOH
#  guard_interpreter   :powershell_script
#    not_if '([System.IO.File]::exists("c:\\setup\\bts\\_chefCustomHostConfigured.lock") )'

# end
# log "#{cookbook_name}:: Custom Hosts Configured"


# powershell_script 'Configure FinSuite File Handlers' do
#     architecture :i386
#   code <<-EOH  

  
# Write-host "Getting BizMgmtDb Server Name"
# $btsConnectionString = "server=.;database=BizTalkMgmtDb;Integrated Security=SSPI;"
# $btsDBServer =  (Get-ItemProperty "hklm:SOFTWARE\\Microsoft\\Biztalk Server\\3.0\\Administration").MgmtDBServer
# $btsMgmtDB =  (Get-ItemProperty "hklm:SOFTWARE\\Microsoft\\Biztalk Server\\3.0\\Administration").MgmtDBName
# $btsConnectionString = "server="+$btsDBServer+";database="+$btsMgmtDB+";Integrated Security=SSPI"
  
# Write-Host "Loading Powershell provider for BizTalk snap-in"
  
# $InitializeDefaultBTSDrive = $false
# Add-PSSnapin -Name BizTalkFactory.Powershell.Extensions
  
# Write-Host $btsDBServer
  
# New-PSDrive -Name BizTalk -Root BizTalk:\\ -PsProvider BizTalk -Instance $btsDBServer -Database $btsMgmtDB
  
# Set-Location -Path BizTalk:

# Write-Host "Checking BizTalk Adapter FILE Handlers"
# Set-Location -Path "Platform Settings\\Adapters\\FILE"

# $LargeDataHostFileHandler = Get-ChildItem | Where-Object{$_.Name -eq "FILE Send Handler (LargeDataHost)"}
# if($LargeDataHostFileHandler.Name -eq $null)
# {
#        Write-Host "Creating LargeDataHost Send File Handler"
#        New-Item -Path 'FILE Send Handler (LargeDataHost)' -HostName LargeDataHost -Direction Send       
# }


# $SndAdapterFileHandler = Get-ChildItem | Where-Object{$_.Name -eq "FILE Send Handler (SndAdapterHost)"}
# if($SndAdapterFileHandler.Name -eq $null)
# {
#        Write-Host "Creating SndAdapter Send File Handler"
#        New-Item -Path 'FILE Send Handler (SndAdapterHost)' -HostName SndAdapterHost -Direction Send       
# }

# $RcvLargeDataHostFileHandler = Get-ChildItem | Where-Object{$_.Name -eq "FILE Receive Handler (LargeDataHost)"}
# if($RcvLargeDataHostFileHandler.Name -eq $null)
# {
#        Write-Host "Creating LargeDataHost Receive File Handler"
#        New-Item -Path 'FILE Receive Handler (LargeDataHost)' -HostName LargeDataHost -Direction Receive       
# }


# $RcvAdapterFileHandler = Get-ChildItem | Where-Object{$_.Name -eq "FILE Receive Handler (RcvAdapterHost)"}
# if($RcvAdapterFileHandler.Name -eq $null)
# {
#        Write-Host "Creating RcvAdapterHost Receive File Handler"
#        New-Item -Path 'FILE Receive Handler (RcvAdapterHost)' -HostName RcvAdapterHost -Direction Receive       
# }


# Write-Host "End BizTalk Adapter FILE Handlers"
# [System.IO.File]::WriteAllText("c:\\setup\\bts\\_chefFileHandler.lock", "complete")
        
#     EOH
#  guard_interpreter   :powershell_script
#    not_if '([System.IO.File]::exists("c:\\setup\\bts\\_chefFileHandler.lock"))'

# end
# log "#{cookbook_name}:: File Handlers Configured"
log "#{cookbook_name}::Custom Hosts configured successfully"
