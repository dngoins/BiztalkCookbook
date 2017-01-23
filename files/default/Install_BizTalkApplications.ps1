
<#
.SYNOPSIS
 Automates BizTalk Application deployment using BTDF 5.0

.DESCRIPTION
 Automates BizTalk Application deployment using BTDF 5.0
  Steps:
   1. It installs the MSI on the specified application path
   2. Calls EnvironmentSettingsExporter to generate the settings xml
   3. Updates Environment Variables
   4. Executes the MSBuild with parameters

.NOTES
 File Name: Install-BizTalkApplication.ps1
 Author: Randy Aldrich Paulo
 Prerequisite: Powershell 2.0, BizTalk Deployment Framework 5.0, BizTalk Server 2010

.PARAMETER MsiFile
 MSI File generated using BizTalk Deployment Framework 5.0

.PARAMETER ApplicationInstallPath
 Location wherein the resource files will be copied, it will be use by the BTDF during the deployment

.PARAMETER Environment
 Name of environment (Local,Dev,Test,Prod) to be used, this value will be passed to
 EnvironmentSettingsExporter and willbe used to construct the environment variable: ENV_SETTINGS

.EXAMPLE
 Install-BizTalkApplication -MsiFile "E:\Installer\Application 1\Application1.msi"
 -ApplicationInstallPath "E:\Program Files\Application 1"
 -Environment DEV

.EXAMPLE
 Install-BizTalkApplication -msi "E:\Installer\Application 1\Application1.msi"
 -path "E:\Program Files\Application 1"
 -env TEST

.EXAMPLE
 Install-BizTalkApplication "E:\Installer\Application 1\Application1.msi"
 "E:\Program Files\Application 1" TEST

.EXAMPLE
 Install-BizTalkApplication "E:\Installer\Application 1\Application1.msi"
 "E:\Program Files\Application 1" TEST -SkipUndeploy $false

#>

 param(
  [Parameter(Position=0,Mandatory=$true,HelpMessage="Msi file should be existing")]
  [ValidateScript({Test-Path $_})]
  [Alias("msi")]
  [string]$MsiFile,
  
  [Parameter(Position=1,HelpMessage="Path wherein the resource file will be installed")]
  [Alias("path")]
  [string]$ApplicationInstallPath,
  
  [Parameter(Position=2,Mandatory=$true,HelpMessage="Only valid parameters are Local,Dev,Test and Prod")]
  [Alias("env")]
  [ValidateSet("Local","Dev","Prod","Test")]
  [string]$Environment,

  [Parameter(Position=3,Mandatory=$true,HelpMessage="Name of BTDF Deployment file")]
  [Alias("dep")]
  [string]$DeploymentFile,
  
  [bool]$BTDeployMgmtDB=$true,
  [bool]$SkipUndeploy=$true
  )

  write-host "Install_BizTalkApplications Started"
 $ErrorActionPreference="Stop"
 
 #Step 2 : Run MSBuild & Deploy
 
  $script=
  {
   <# Start Step 2.2 Run EnvironmentSettingsExporter, this one generates the xml file
   (Exported_DevSettings.xml, Exported_LocalSettings.xml etc..)
   #>
   <# Find all existing Exported_xxxSettings.xml files and rename to FSPxxx_Settings.xml #>
   $exportDir = (Join-Path $ApplicationInstallPath "Deployment\\EnvironmentSettings")
   $files = [System.IO.Directory]::GetFiles($exportDir)
   foreach($file in $files)
	{
		if($file.Contains("Export_"))
		{
			<# we need to rename to FSPxxx_Settings.xml #>
			$_file = $file.Replace("Export_", "Custom")
			$finalName = $_file.Replace("Settings.xml", "_Settings.xml")
      write-host "Moving File: " + $file + " to file: " + $finalName
			[System.IO.File]::Move($file, $finalName)
		}
	}

   $args = "`"" + (Join-Path $ApplicationInstallPath "Deployment\\EnvironmentSettings\\SettingsFileGenerator.xml") + "`"" + " Deployment\\EnvironmentSettings"
   $exePath = ("`"" + (Join-Path $ApplicationInstallPath "Deployment\\Framework\\DeployTools\\EnvironmentSettingsExporter.exe") + "`"")
   Write-Host " Generating Environment Settings File.."  -ForegroundColor Cyan
   Write-Host " Location: $exePath" -ForegroundColor DarkGray
   Write-Host "  Args: $args" -ForegroundColor DarkGray

   $exitCode = (Start-Process -FilePath $exePath -ArgumentList $args -Wait -PassThru).ExitCode
   Write-Host " Exit Code: $exitCode"
   
   if($exitCode -ne 0)
   {
    Write-Error " Generating Environment Settings File failed!, Exit Code: $exitCode"
   }
   Write-Host " Generated Environment Settings File. " -ForegroundColor Green
   Write-Host ""
   <# End Step 2.2 Run EnvironmentSettingsExporter, this one generates the xml file
   (Exported_DevSettings.xml, Exported_LocalSettings.xml etc..)#>
   <# Start Step 2.3 Set the Environment Variables ENV_SETTINGS and BT_DEPLOY_MGMT_DB #>
   $settingsFile = "Deployment\\EnvironmentSettings\\Custom{0}_Settings.xml" -f $Environment
   $EnvSettings =Join-Path $ApplicationInstallPath $settingsFile

   Write-Host " Setting Environment Variables"  -ForegroundColor Cyan
   
   Write-Host "      ENV_SETTINGS = $EnvSettings" -ForegroundColor DarkGray;
   Set-Item Env:\ENV_SETTINGS -Value $EnvSettings
   
   Write-Host  " BT_DEPLOY_MGMT_DB = $BTDeployMgmtDB"  -ForegroundColor DarkGray;
   Set-Item Env:\BT_DEPLOY_MGMT_DB -Value $BTDeployMgmtDB
   
   Write-Host " Setted Environment Variables"  -ForegroundColor Green
   Write-Host ""
   <# End Step 2.3 Set the Environment Variables ENV_SETTINGS and BT_DEPLOY_MGMT_DB #>
   
   <# Start Step 2.4 Execute MS Build with parameters #>
   
   #Get .NET Version
   $dotNetVersion = gci 'HKLM:\\SOFTWARE\Microsoft\\NET Framework Setup\\NDP' | sort pschildname -des | select -fi 1 -exp pschildname
   if($dotNetVersion = "v4.0") { $dotNetVersion = "v4.0.30319" } #Include other info if .NET 4.0
   
   if (Test-Path ( Join-Path $env:windir "Microsoft.NET\\Framework\\$dotNetVersion\\MSBuild.exe" ))
   {
    $BTDFMSBuildPath = Join-Path $env:windir "Microsoft.NET\\Framework\\$dotNetVersion\\MSBuild.exe"
    Write-Host " Using MSBuild $dotNetVersion" -ForegroundColor DarkGray
   }
   else
   {
    Write-Error " MSBuild not found."
   }
   
   #Assign MS Build Params   
   $parms="DeployBizTalkMgmtDB=$BTDeployMgmtDB;Configuration=Server;SkipUndeploy=$SkipUndeploy;"
   $logger="FileLogger,Microsoft.Build.Engine;logfile=`"" + ( Join-Path $ApplicationInstallPath "DeployResults\\DeployResults.txt" ) + "`""
   $deployFile = (Join-Path $ApplicationInstallPath "Deployment\\")
   $btdfFile="`"" +  (Join-Path $deployFile $DeploymentFile) + "`""
   $args = "/p:{1} /l:{2} {0} " -f $btdfFile,$parms,$logger
   
   Write-Host " Executing MSBuild from: $BTDFMSBuildPath"  -ForegroundColor Cyan
   Write-Host " ArgList: $args" -ForegroundColor DarkGray
   
   #Check MSBuild Return Code
   $exitCode = (Start-Process -FilePath $BTDFMSBuildPath -ArgumentList $args -Wait -Passthru).ExitCode
   Write-Host " Exit Code: $exitCode"
   Write-Host ""
   if($exitCode -ne 0)
   {
    Write-Error " Error while calling MSBuild, Exit Code: $exitCode"
   }
  
   #Copy Log File
   Write-Host " Copying  Log file."
   $args =  "Deployment\\Framework\\CopyDeployResults.msbuild /nologo"
   Start-Process -FilePath $BTDFMSBuildPath -ArgumentList $args
   
   <# End Step 2.4 Execute MS Build with parameters #>
  }
 
  Write-Host " Running MS Build and deploying.." -ForegroundColor Cyan
  Invoke-Command -scriptblock $script
  Write-Host " Deployed application" -ForegroundColor Green

