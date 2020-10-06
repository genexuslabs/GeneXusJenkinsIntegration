param (
    [string] $JLOG = $(throw "missing jenkis.log path")
)
### INSTALL CHOCOLATEY
$testchoco = powershell choco -v
if(-not($testchoco)){
    Write-Output((Get-Date -Format G) + " INFO installing Chocolatey") | Tee-Object -FilePath $JLOG -Append -Verbose
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
else{
    Write-Output((Get-Date -Format G) + " INFO chocolatey is up to version $testchoco") | Tee-Object -FilePath $JLOG -Append -Verbose
}