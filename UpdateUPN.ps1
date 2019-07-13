#
# UpdateUPN.ps1
# Mitch King @365Guy
#


# Get all AD users with a primary SMTP address
$UsersWithSMTP = Get-ADUser -SearchBase "DC=Domain,DC=com" -LdapFilter '(proxyAddresses=*)'
# Loop through all accounts
foreach ($user in $UsersWithSMTP)
{
# Get the primary SMTP address (UPPER CASE)
$PrimarySMTP = Get-ADUser $user -Properties proxyAddresses | Select -Expand proxyAddresses | Where {$_ -clike "SMTP:*"}
# Remove the protocol specification from the start of the address
$newUPN = $PrimarySMTP.SubString(5)
# Update the user with their new UPN
Set-ADUser $user -UserPrincipalName $newUPN
}