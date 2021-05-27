param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
### INSTALL CHOCOLATEY
$ChocoInstaller = "$ROOT\core\utils\Installers\ChocoInstaller.ps1"
$Comm_1 = {& $ChocoInstaller $JLOG }
Invoke-Command -ScriptBlock $Comm_1

### INSTALL DEPENDENCIES
$IOper = "$ROOT\core\tools\InstallerOperator.ps1"
$FilePath = "$ROOT\resources\data\dependencies.txt"
$DependencieList = Get-Content -Path $FilePath
foreach($Package in $DependencieList)
{
    $Comm = {&$IOper $Package $JLOG (0 -eq 1) }
    Invoke-Command -ScriptBlock $Comm
}
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#