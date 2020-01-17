#requires -version 2
<#
.SYNOPSIS
    This script enables you to export all users in Microsoft 365 that have admin roles assigned to them.

.DESCRIPTION
    This script enables you to export all users in Microsoft 365 that have admin roles assigned to them.

.PARAMETER ExportCsvPath
    To export to CSV, specify a path to the CSV. If no path is specified, the output will be written to the console.

.INPUTS
    None

.OUTPUTS
    If specified, a CSV containing the data, written to ExportCsvPath

.NOTES
    Version:          1.1
    Template version: 1.4
    Author:           Axel Timmermans
    Creation Date:    2020-01-17
    Last change:      Added help text
  
.EXAMPLE
    To get all users that have admin roles assigned, and write this to the console:
    .\Get-M365AdminRoles.ps1

.EXAMPLE
    To get all users that have admin roles assigned, and write this to a CSV:
    .\Get-M365AdminRoles.ps1 -ExportCsvPath "C:\Temp\ContosoAdminRoles.csv"

#>

#region Parameters-----------------------------------------------------------------------------------------
Param(
    [Parameter(Mandatory=$false)]$ExportCsvPath
)
#endregion-------------------------------------------------------------------------------------------------

#region Initializations------------------------------------------------------------------------------------
#endregion-------------------------------------------------------------------------------------------------

#region Declarations---------------------------------------------------------------------------------------
#endregion-------------------------------------------------------------------------------------------------

#region Functions------------------------------------------------------------------------------------------
Function CheckMsolConnection {
    #Check for MSOnline module, install and/or connect to MSOnline
    if(!(Get-Module -ListAvailable -Name MSOnline)) {
        Write-Host "MSOnline module not found, will try to install this in user context"
        Install-Module -Name MSOnline -Scope CurrentUser -Force
    }
    Write-Host "Now connecting to MSOnline"
    Connect-MsolService
}
#endregion-------------------------------------------------------------------------------------------------


#region Execution------------------------------------------------------------------------------------------
CheckMsolConnection

#Get all roles
$Roles = Get-MsolRole
    
#Loop roles and get members
$RolesAndMembers = @()
ForEach($Role in $Roles) {
    $RolesAndMembers += Get-MsolRoleMember -All -RoleObjectId $Role.ObjectId | Select-Object @{Name="Role";Expression={$Role.Name}},RoleMemberType,EmailAddress,DisplayName
}

#Show on console or export to CSV
if($ExportCsvPath) {
    $RolesAndMembers | Export-Csv -Path $ExportCsvPath -NoTypeInformation -Force
} else {
    $RolesAndMembers
}
#endregion-------------------------------------------------------------------------------------------------
