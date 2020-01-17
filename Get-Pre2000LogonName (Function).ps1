Function Get-Pre2000LogonName {
    #requires -version 2
    <#
    .SYNOPSIS
        Get the pre Windows 2000 logon name for the logged on user

    .DESCRIPTION
        Get the pre Windows 2000 logon name for the logged on user

    .INPUTS
        None

    .OUTPUTS
        Pre Windows 2000 logon name for the logged on user in the format CONTOSO\JohnDoe

    .NOTES
        Version:          1.2
        Template version: 1.4
        Author:           Axel Timmermans
        Creation Date:    2020-01-17
        Last change:      Updates help text, prepared for publication
      
    .EXAMPLE
        $Pre2000 = Get-Pre2000LogonName
        This will fill the variable $Pre2000 with the value CONTOSO\JohnDoe
    #>
    $Pre2000 = "$env:USERDOMAIN\$env:USERNAME"
    If($Pre2000 -eq $null){
        Write-Error "Variables not detected, value is empty"
    }else{
        Return $Pre2000
    }
}
