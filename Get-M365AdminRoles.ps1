<#
This script enables you to export all users in Microsoft 365 that have admin roles assigned to them.
By defining the ExportToCsvPath parameter, you can export the output to CSV.
#>

#Parameters
    Param(
        [Parameter(Mandatory=$false)]$ExportToCsvPath
    )

#Check for MSOnline module, install and/or connect to MSOnline
    if(!(Get-Module -ListAvailable -Name MSOnline)) {
        Write-Host "MSOnline module not found, will try to install this in user context"
        Install-Module -Name MSOnline -Scope CurrentUser -Force
    }
    Write-Host "Now connecting to MSOnline"
    Connect-MsolService

#Get all roles
    $Roles = Get-MsolRole
    
#Loop roles and get members
    $RolesAndMembers = @()
    ForEach($Role in $Roles) {
        $RolesAndMembers += Get-MsolRoleMember -All -RoleObjectId $Role.ObjectId | Select-Object @{Name="Role";Expression={$Role.Name}},RoleMemberType,EmailAddress,DisplayName
    }

#Show on console or export to CSV
    If($ExportToCsvPath) {
        $RolesAndMembers | Export-Csv -Path $ExportToCsvPath -NoTypeInformation -Force
    }
    Else {
        $RolesAndMembers
    }

#Pause and exit
    Read-Host -Prompt "Finished, press Enter to exit"
    Exit