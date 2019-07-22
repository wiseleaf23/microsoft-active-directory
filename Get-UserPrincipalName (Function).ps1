Function Get-UserPrincipalName {
    #Version 1.1
    try{
        $objUser = New-Object System.Security.Principal.NTAccount($Env:USERNAME)
        $strSID = ($objUser.Translate([System.Security.Principal.SecurityIdentifier])).Value
        $basePath = "HKLM:\SOFTWARE\Microsoft\IdentityStore\Cache\$strSID\IdentityCache\$strSID"
        if((test-path $basePath) -eq $False){
            $userId = $Null
        }
        $userId = (Get-ItemProperty -Path $basePath -Name UserName).UserName
        Return $userId
    }catch{
        Write-Error "Failed to auto detect user principal name"
    }
}