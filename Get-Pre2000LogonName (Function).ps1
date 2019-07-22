Function Get-Pre2000LogonName {
    <#
    .SYNOPSIS
      Get the pre Windows 2000 logon name for the logged on user

    .DESCRIPTION
      This function will get the pre Windows 2000 logon name for the logged on user in the format CONTOSO\JohnDoe

    .PARAMETER
      None

    .INPUTS
      None

    .OUTPUTS
      Pre Windows 2000 logon name for the logged on user in the format CONTOSO\JohnDoe

    .NOTES
      Version:          1.1
      Template version: 1.3
      Author:           Axel Timmermans
      Creation Date:    2019-07-22
      Purpose/Change:   Added if statement to catch empty variable
  
    .EXAMPLE
      $Pre2000 = Get-Pre2000LogonName
  
      This will fill the variable $Pre2000 with the value CONTOSO\JohnDoe
    #>
    
    $Pre2000 = "$env:USERDOMAIN\$env:USERNAME"
    If($Pre2000 -eq $null){
        Write-Error "Variables not detected, value is empty"
    }Else{
        Return $Pre2000
    }
}
