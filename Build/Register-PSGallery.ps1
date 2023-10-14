$ProviderName = "PowerShellGet"

$AllPackageProviders = Get-PackageProvider
if ($PSVersionTable.PSVersion -lt [version]"6.0")
{
    $SecurityProtocol = @()
    $SecurityProtocol += [System.Net.ServicePointManager]::SecurityProtocol
    $SecurityProtocol += [System.Net.SecurityProtocolType]::Tls12
    [System.Net.ServicePointManager]::SecurityProtocol = $SecurityProtocol

    if ("NuGet" -notin $AllPackageProviders.Name)
    {
        Install-PackageProvider -Scope CurrentUser -Name "NuGet"
    }
}

if ($ProviderName -notin $AllPackageProviders.Name)
{
    "Didn't find the $ProviderName provider, so install the PackageManagement module that's included in PowerShellGet"
    Install-PackageProvider -Name $ProviderName -Force -Verbose
    if (-not (Get-Module -Name PowerShellGet -ListAvailable))
    {
        Install-Module -Name PowerShellGet -Repository PSGallery -Scope CurrentUser -Force -Verbose
        Import-Module -Name PowerShellGet -Force
    }
}
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -Verbose
