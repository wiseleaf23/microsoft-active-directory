#requires -version 2
<#
.SYNOPSIS
  Clean-up AAD devices for cloud-only environments. Hybrid not (yet) supported

.DESCRIPTION
  Clean-up AAD devices for cloud-only environments. Hybrid not (yet) supported

.PARAMETER ExportDevices
    Specify to export devices to CSV

.PARAMETER CsvToImport
    Specify exported CSV files to process (disable, remove ir enable)

.INPUTS
    You can input a CSV when disabling, removing or enabling

.OUTPUTS
    When exporting, a CSV file will be created in the folder you specified

.NOTES
  Version:          1.0
  Template version: 1.3
  Author:           Axel Timmermans
  Creation Date:    2019-12-30
  Purpose/Change:   Initial script development 

  Use Get-MsolDevice to prevent deletion of System-Managed devices (https://docs.microsoft.com/en-us/azure/active-directory/devices/manage-stale-devices#system-managed-devices)
  More info https://docs.microsoft.com/en-us/azure/active-directory/devices/manage-stale-devices
  
.EXAMPLE
  To export devices marked as stale by your policy, run the script like:
  '.\Clean Azure AD devices.ps1' -ExportDevices -TimeframeInDays 90 -ExportFolder "D:\"

  To import devices from the CSV created and disable:
  '.\Clean Azure AD devices.ps1' -CsvToImport "Devices older than 2019-10-01 for contoso.csv" -Action Disable

  If you made a mistake with disabling, you can also use the script to enable the devices again:
  '.\Clean Azure AD devices.ps1' -CsvToImport "Devices older than 2019-10-01 for contoso.csv" -Action Enable

#>

#region Parameters-----------------------------------------------------------------------------------------

Param(
    [Parameter(Mandatory=$true, ParameterSetName="Export",
    HelpMessage="Specify to export stale devices to CSV")]
    [switch]
    $ExportDevices,

    [Parameter(Mandatory=$true, ParameterSetName="Export",
    HelpMessage="Timeframe in days after which you want to process stale devices")]
    $TimeframeInDays,

    [Parameter(Mandatory=$true, ParameterSetName="Export",
    HelpMessage="Folder you want to export the CSV to")]
    [ValidateScript({Test-Path $_})]
    $ExportFolder,

    [Parameter(Mandatory=$true, ParameterSetName="Import",
    HelpMessage="Path to CSV with devices exported earlier, to be processed for disabling or removal")]
    [ValidateScript({Test-Path $_})]
    $CsvToImport,
    
    [Parameter(Mandatory=$true, ParameterSetName="Import",
    HelpMessage="Specify what to do with the stale devices from the CSV. Re-enabling devices is also possible, if you made a mistake with disabling")]
    [ValidateSet("Disable", "Remove","Enable")]
    $Action
)

#endregion-------------------------------------------------------------------------------------------------



#Connect to MSOL (check module first)
Write-Host ""
Write-Host "Connecting to MSOL..." -ForegroundColor Green
If(!(Get-Module -ListAvailable -Name "MSOnline")){
        Write-Warning "MSOnline module not detected, attempting to install in user context"
        try{Install-Module -Name "MSOnline" -Scope CurrentUser}
        catch{Write-Error "Installation of MSOnline module failed, cannot continue"}
}
try{Connect-MsolService}
catch{Write-Error "Connecting to MSOL failed, cannot continue"}

#Export devices to CSV
if ($ExportDevices) {
    #Define timeframe for stale devices
    $Today = Get-Date -Format "yyyy-MM-dd"
    $LogonTimeBefore = (Get-Date -Date $Today).AddDays(-$TimeframeInDays)
    $LogonTimeBefore = (Get-Date -Format "yyyy-MM-dd" -Date $LogonTimeBefore)

    #Inform host
    Write-Host "Will now export devices older than $LogonTimeBefore to CSV" -ForegroundColor Green

    #Define CSV for export name
    $InitialDomain = (Get-MsolDomain | Where-Object{$_.IsInitial -eq $true}).Name.Replace(".onmicrosoft.com","")
    $CsvToExport = "$ExportFolder\Devices older than $LogonTimeBefore for $InitialDomain.csv"

    #Get devices to be processed
    Get-MsolDevice -All -LogonTimeBefore $LogonTimeBefore | Select-Object -Property Enabled, DeviceId, DisplayName, DeviceTrustType, ApproximateLastLogonTimestamp | Export-Csv -NoTypeInformation -Path $CsvToExport    
}

#Process devices from CSV
switch ($Action) {
    "Disable" {
        $Devices = Import-Csv -Path $CsvToImport
        ForEach($Device in $Devices){
            Write-Host "Now disabling device $($Device.DisplayName)"
            Disable-MsolDevice -DeviceId $Device.DeviceId
        }
    }
    "Remove" {
        $Devices = Import-Csv -Path $CsvToImport
        ForEach($Device in $Devices){
            Write-Host "Now removing device $($Device.DisplayName)"
            Remove-MsolDevice -DeviceId $Device.DeviceId
        }
    }
    "Enable" {
        $Devices = Import-Csv -Path $CsvToImport
        ForEach($Device in $Devices){
            Write-Host "Now enabling device $($Device.DisplayName)"
            Enable-MsolDevice -DeviceId $Device.DeviceId
        }
    }
    Default {}
}
