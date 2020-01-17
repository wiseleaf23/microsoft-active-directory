Function Get-UserPrincipalName {
    #requires -version 2
    <#
    .SYNOPSIS
        This function will detected the logged on user's User Principal Name (UPN)

    .DESCRIPTION
        The function will detect the UPN by looking up the corresponding values in the registry. When these can't be found, or the UPN is Null, an error is returned.

    .INPUTS
        None

    .OUTPUTS
        User Principal Name, also known as UPN

    .NOTES
        Version:          1.3
        Template version: 1.4
        Author:           Axel Timmermans
        Creation Date:    2020-01-17
        Last change:      Updated help text, prepared for publication

    .EXAMPLE
        $UPN = Get-UserPrincipalName
    #>
    try{
        $objUser = New-Object System.Security.Principal.NTAccount($Env:USERNAME)
        $strSID = ($objUser.Translate([System.Security.Principal.SecurityIdentifier])).Value
        $basePath = "HKLM:\SOFTWARE\Microsoft\IdentityStore\Cache\$strSID\IdentityCache\$strSID"
        $UPN = (Get-ItemProperty -Path $basePath -Name UserName).UserName
        #Write error if UPN is Null
        If(!$UPN){
            Write-Error "Null UPN detected"
        }
        Return $UPN
    }catch{
        Write-Error "Failed to auto detect user principal name"
    }
}