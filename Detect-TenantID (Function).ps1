Function Detect-TenantID {
    #Version 1.0
    Param(
        [Parameter(Mandatory=$true,HelpMessage="Specify username for which to detect the tenant ID")]
        [string]
        $Username
    )
    $tenantId = (Invoke-RestMethod "https://login.windows.net/$($Username.Split("@")[1])/.well-known/openid-configuration" -Method GET).userinfo_endpoint.Split("/")[3]
    Return $tenantId
}