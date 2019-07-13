#Parameters
    Param(
        [Parameter(Mandatory=$false)]$ExportToCsvPath
    )

#Connect to MSOnline
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

#Pause, clear and exit
    Read-Host -Prompt "Finished, press Enter to exit"
    Exit