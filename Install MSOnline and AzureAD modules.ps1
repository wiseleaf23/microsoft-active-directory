Install-PackageProvider -Name NuGet -Force -Confirm:$false
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module AzureAD -Force -Confirm:$false
Install-Module MSOnline -Force -Confirm:$false
Exit
