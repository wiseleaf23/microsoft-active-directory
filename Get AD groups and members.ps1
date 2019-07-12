# Get the AD groups
$Groups = Get-ADGroup -Filter * -SearchBase "ou=DATA groepen,ou=Groups,ou=Kindercentra De Roef,dc=deroef,dc=lan"

# Get the members from the AD groups and put them in 
$Results = foreach( $Group in $Groups ){
    Get-ADGroupMember -Identity $Group | foreach {
        [pscustomobject]@{
        GroupName = $Group.Name
        Name = $_.Name
        SamAccountName = $_.SamAccountName
        }
    }
}

$Results | Export-CSV C:\ADGroupMembers2.csv -NoTypeInformation