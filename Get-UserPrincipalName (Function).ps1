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
        Version:          1.4
        Template version: 1.4
        Author:           Axel Timmermans
        Creation Date:    2020-01-17
        Last change:      Updated function - Updated help text, prepared for publication

    .EXAMPLE
        $UPN = Get-UserPrincipalName
    #>
    try{
        $SID = ((New-Object System.Security.Principal.NTAccount($Env:USERNAME)).Translate([System.Security.Principal.SecurityIdentifier])).Value
        $UPN = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\IdentityStore\Cache\$SID\IdentityCache\$SID" -Name UserName).UserName
        #Write error if UPN is Null
        If(!$UPN){
            Write-Error "Null UPN detected"
        }else{
            Return $UPN
        }
    }catch{
        Write-Error "Failed to auto detect user principal name"
    }
}