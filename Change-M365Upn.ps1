#Changes UPN for Microsoft 365 accounts
#For options with CSV: https://www.morgantechspace.com/2018/03/how-to-change-userprincipalname-of-office-365-user-powershell.html

#Variables
    $oldDomain = Read-Host -Prompt "Please enter the old suffix, for example: contoso.onmicrosoft.com"
    $newDomain = Read-Host -Prompt "Please enter the new suffix, for example: contoso.com"
    

#Execute
    #Get all users
    Get-AzureADUser -All $True | Where { $_.UserPrincipalName.ToLower().EndsWith($oldDomain) }
    #Loop trhrough users to change UPN
    ForEach {
         $newupn = $_.UserPrincipalName.Split("@")[0] + "@" + $newDomain
         Write-Host "Changing UPN value from: "$_.UserPrincipalName" to: " $newupn -ForegroundColor Green
         Set-AzureADUser -ObjectId $_.UserPrincipalName  -UserPrincipalName $newupn
    }