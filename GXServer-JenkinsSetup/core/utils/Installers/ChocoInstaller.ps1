param (
    [string] $JLOG = $(throw "missing jenkis.log path")
)
### INSTALL CHOCOLATEY
$ChocoInstalled = $false
if (Get-Command choco.exe -ErrorAction SilentlyContinue) 
{
    $ChocoInstalled = $true
    $testchoco = powershell.exe choco -v
    Write-Output((Get-Date -Format G) + " INFO chocolatey is up to version $testchoco") | Tee-Object -FilePath $JLOG -Append -Verbose
}
else
{
    Write-Output((Get-Date -Format G) + " INFO installing Chocolatey") | Tee-Object -FilePath $JLOG -Append -Verbose
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

}
