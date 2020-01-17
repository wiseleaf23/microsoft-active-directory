#requires -version 2
<#
.SYNOPSIS
    Change a UPN for a local Active Directory user

.DESCRIPTION
    Change a UPN for a local Active Directory user

.PARAMETER CurrentSuffix
    Suffix to be replaced, for example contoso.local

.PARAMETER NewSuffix
    New suffix, for example contoso.com

.PARAMETER SearchBase
    Organizational unit that contains the identities for which you wish to replace the suffix

.INPUTS
    None

.OUTPUTS
    None

.NOTES
    Version:          1.1
    Template version: 1.4
    Author:           Axel Timmermans
    Creation Date:    2020-01-17
    Last change:      Added help text and parameters, prepared for publication
  
.EXAMPLE
    To change from contoso.local to contoso.com in the Organizational Unit "OU=Users,OU=Contoso,DC=contoso,DC=local" , to be able to sync the domain with Office 365, run:
    .\Change-LocalADUPN.ps1 -CurrentSuffix contoso.local -NewSuffix contoso.com  -SearchBase "OU=Users,OU=Contoso,DC=contoso,DC=local"

#>

#region Parameters-----------------------------------------------------------------------------------------
Param (
    [Parameter(Mandatory=$true)][string]$CurrentSuffix,
    [Parameter(Mandatory=$true)][string]$NewSuffix,
    [Parameter(Mandatory=$true)][string]$SearchBase
)
#endregion-------------------------------------------------------------------------------------------------

#region Execution------------------------------------------------------------------------------------------
#Import ActiveDirectory module
try{Import-Module ActiveDirectory}
catch{Throw "Could not load ActiveDirectory module, cannot continue"}

#Get and set UPN's
Get-ADUser -SearchBase $SearchBase -Filter * | ForEach-Object {
    $newUpn = $_.UserPrincipalName.Replace($CurrentSuffix,$NewSuffix)
    Set-ADUser $_ -UserPrincipalName $newUpn
}
#endregion-------------------------------------------------------------------------------------------------