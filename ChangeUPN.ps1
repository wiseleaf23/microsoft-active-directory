#This script changes a UPN
#For instance: from domain.local to domain.com, to be able to sync the domain with Office 365

Import-Module ActiveDirectory

#Variables
$oldSuffix = "unimop.lan"
$newSuffix = "unimop.com"
$ou = "OU=Users,OU=Unimop,DC=unimop,DC=lan"

#Get and set UPN's
Get-ADUser -SearchBase $ou -Filter * | ForEach-Object {
    $newUpn = $_.UserPrincipalName.Replace($oldSuffix,$newSuffix)
    Set-ADUser $_ -UserPrincipalName $newUpn
}

exit