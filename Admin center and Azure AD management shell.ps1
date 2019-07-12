#Execute this if running PowerShell scripts is not allowed yet: Set-ExecutionPolicy Unrestricted

#Restarts PowerShell with -ExecutionPolicy ByPass and -NoExit, the same script, and 1
param($Work)
if (!$Work)
{
    PowerShell -ExecutionPolicy ByPass -NoExit -File $MyInvocation.MyCommand.Path 1
    Return
}

#Writes to host to give information
Write-Host ""
Write-Host "For this script to work, make sure you have the required software installed. (https://technet.microsoft.com/en-us/library/dn975125.aspx)"
Write-Host ""

Write-Host "Do not forget to close the session when you are finished by using 'Disconnect-AzureAD'"
Pause

#Variables at start of script
$Credential = Get-Credential

#Open connection to management shells
Connect-MsolService -Credential $Credential
Connect-AzureAD -Credential $Credential
