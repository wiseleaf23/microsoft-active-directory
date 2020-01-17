#requires -version 2
<#
.SYNOPSIS
    Changes UPN for Microsoft 365 accounts

.DESCRIPTION
    Changes UPN for Microsoft 365 accounts. Requires connection to AzureAD via AzureAD PowerShell module.

.PARAMETER CurrentDomain
    Current suffix that will be replaced with NewSuffix

.PARAMETER NewDomain
    Suffix to configure replacing CurrentDomain

.INPUTS
    None

.OUTPUTS
    None

.NOTES
    Version:          1.1
    Template version: 1.4
    Author:           Axel Timmermans
    Creation Date:    2020-01-17
    Last change:      Added help text and parameters
  
.EXAMPLE
    To change user suffixes from contoso.onmicrosoft.com to contoso.com:

    Connect to AzureAD (not MSOnline)
    .\Change-M365UPN -CurrentDomain contoso.onmicrosoft.com -NewDomain contoso.com

    For options with CSV: https://www.morgantechspace.com/2018/03/how-to-change-userprincipalname-of-office-365-user-powershell.html

#>

#region Parameters-----------------------------------------------------------------------------------------

Param (
    [Parameter(Mandatory=$true)][string]$CurrentDomain,
    [Parameter(Mandatory=$true)][string]$NewDomain
)

#endregion-------------------------------------------------------------------------------------------------

#region Initializations------------------------------------------------------------------------------------



#endregion-------------------------------------------------------------------------------------------------

#region Declarations---------------------------------------------------------------------------------------



#endregion-------------------------------------------------------------------------------------------------

#region Functions------------------------------------------------------------------------------------------



#endregion-------------------------------------------------------------------------------------------------


#region Execution------------------------------------------------------------------------------------------

#Check for connection to AzureAD
if(!(Get-AzureADUser -Top 1 -ErrorAction SilentlyContinue)){
    Throw "No connection to Azure AD, script cannot continue"
}

#Get all users
$Users = Get-AzureADUser -All $True | Where-Object { $_.UserPrincipalName.ToLower().EndsWith($CurrentDomain) }
#Loop through users to change UPN
ForEach ($User in $Users) {
        $NewUPN = $_.UserPrincipalName.Split("@")[0] + "@" + $NewDomain
        Write-Host "Changing UPN value from: "$_.UserPrincipalName" to: " $NewUPN -ForegroundColor Green
        Set-AzureADUser -ObjectId $_.UserPrincipalName  -UserPrincipalName $NewUPN
}

#endregion-------------------------------------------------------------------------------------------------