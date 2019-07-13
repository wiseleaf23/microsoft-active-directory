#Run the command Get-MsolAccountSku to retrieve a list of the available SKU's

#Variables
    $oldSKU = "Spelenderwijs:STANDARDWOFFPACK" #old SKU, for example "Contoso:STANDARDWOFFPACK"
    $newSKU = "Spelenderwijs:ATP_ENTERPRISE" #for instance "Contoso:STANDARDPACK"
    $backupCSV = "C:\OfficeGrip\BackupCSV.csv" #location for backup CSV

#Replace
    #Wanna see the users and licenses first? Run $users | Select-Object DisplayName,Licenses
    $users = Get-MsolUser -All | Where-Object {($_.licenses).AccountSkuId -match $oldSKU}
    $users | Export-Csv -Path $backupCSV -NoTypeInformation
    foreach ($user in $users) {
        $upn=$user.userPrincipalName
        Set-MsolUserLicense -UserPrincipalName $upn -AddLicenses $newSKU -RemoveLicenses $oldSKU
    }

#Add
    Write-Host ""
    Write-Host "Did you create a backup of all users' license assigment?" -ForegroundColor Yellow
    Pause
    $users = Get-MsolUser -All | Where-Object {$_.isLicensed -eq "TRUE"}
    foreach ($user in $users) {
        $upn=$user.userPrincipalName
        Set-MsolUserLicense -UserPrincipalName $upn -AddLicenses $newSKU
    }



