Function Detect-TenantName {
    #Version 1.0
    Param(
        [Parameter(Mandatory=$true,HelpMessage="Specify username for which to detect the tenant name")]
        [string]
        $Username
    )
    $TenantName = (Invoke-RestMethod -Uri ("https://login.microsoftonline.com/GetUserRealm.srf?login=$Username")).FederationBrandName
    Return $TenantName
}