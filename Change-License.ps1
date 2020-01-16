#requires -version 2
<#
.SYNOPSIS
    Replace a Microsoft 365 SKU with a different SKU

.DESCRIPTION
    Replace a Microsoft 365 SKU with a different SKU

.PARAMETER CurrentSKU
    SKU that license needs to be added to, or SKU that will be replaced, for example "contoso:STANDARDWOFFPACK"

.PARAMETER NewSKU
    SKU that will be assigned instead of CurrentSKU, for example "contoso:STANDARDPACK"

.PARAMETER Action
    Specify if you want to replace CurrentSKU with NewSKU, or if you want to add NewSKU to users with CurrentSKU

.PARAMETER BackupCSV
    Filepath to which a backup of the current license assignments is written. For example "C:\Temp\LicenseBackup.csv"

.INPUTS
    None

.OUTPUTS
    Backup file in CSV of current license assigments at the path in $BackupCSV

.NOTES
    Version:          1.1
    Template version: 1.4
    Author:           Axel Timmermans
    Creation Date:    2020-01-16
    Last change:      Added help text and parameters
  
.EXAMPLE
    Run the command Get-MsolAccountSku to retrieve a list of the available SKU's

    To replace the license "contoso:STANDARDWOFFPACK" with "contoso:STANDARDPACK" and create a backup, run:
    .\Change-License.ps1 -CurrentSKU "contoso:STANDARDWOFFPACK" -NewSKU "contoso:STANDARDPACK" -Action Replace -BackupCSV "C:\Temp\LicenseBackup.csv"

    To add the license "contoso:ATPENTERPRISE" to user with "contoso:STANDARDWOFFPACK" and skip creating a backup, run:
    .\Change-License.ps1 -CurrentSKU "contoso:STANDARDWOFFPACK" -NewSKU "contoso:ATPENTERPRISE" -Action Add

#>

#region Parameters-----------------------------------------------------------------------------------------

Param (
    [Parameter(Mandatory=$true)][string]$CurrentSKU,
    [Parameter(Mandatory=$true)][string]$NewSKU,
    [Parameter(Mandatory=$true)][ValidateSet("Add","Replace")][string]$Action,
    [Parameter(Mandatory=$false)][string]$BackupCSV
)

#endregion-------------------------------------------------------------------------------------------------

#region Functions------------------------------------------------------------------------------------------

Function CheckAndConnectMSOnline{
    #Check for module
    If(!(Get-Module -Name MSOnline -ListAvailable)){
        Write-Warning "MSOnline module not installed, installing in CurrentUser scope"
        Install-Module -Name MSOnline -Scope CurrentUser -Force
    }
    #Module should be installed, check for existing connection
    If(!(Get-MsolUser -MaxResults 1 -ErrorAction SilentlyContinue)){
        Write-Output "Not (properly) connected to MSOnline, will now call Connect-MsolService"
        Connect-MsolService
    }else{
        Write-Warning "Already connected to MSOnline, please make sure this is the right tenant"
    }
}
Function BackupToCSV {
    Param (
        [Parameter(Mandatory=$true)][string]$BackupCSV
    )
    if(!($BackupCSV)){
        Write-Warning "You did not specify a backup CSV, are you sure? Press CTRL+C to cancel or Enter to continue"
        Pause
    }else{
        try{$Users | Export-Csv -Path $BackupCSV -NoTypeInformation -Force}
        catch{throw "Failed to create backup CSV"}
    }
}

#endregion-------------------------------------------------------------------------------------------------

#region Execution------------------------------------------------------------------------------------------

#Connect to MSOnline
CheckAndConnectMSOnline

#Get users and assigned licenses
$Users = Get-MsolUser -All | Where-Object {($_.licenses).AccountSkuId -match $CurrentSKU}

#Backup
BackupToCSV

#Process
switch ($Action) {
    "Replace" {
        #Wanna see the users and licenses first? Run $Users | Select-Object DisplayName,Licenses
        foreach ($User in $Users) {
            $UPN = $User.userPrincipalName
            Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $NewSKU -RemoveLicenses $CurrentSKU
        }
    }
    "Add" {
        foreach ($User in $Users) {
            $UPN = $User.userPrincipalName
            Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $NewSKU
        }
    }
    Default {}
}

#endregion-------------------------------------------------------------------------------------------------





