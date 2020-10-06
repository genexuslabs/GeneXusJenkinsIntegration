param (
    [string] $ROOT = $(throw "miss script root"),
    [string] $JLOG = $(throw "missing jenkis.log path"),
    [string] $isDebug
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
#### CHECK IF .\conig\Jconfig.json IS EMPTY
$check = {& "$ROOT\config\helpers\checker.ps1" $ROOT }
$isChecked = Invoke-Command -ScriptBlock $check
if($isChecked -eq 1)
{    
    Write-Output((Get-Date -Format G) + " ERROR Value cannot be empty in ..\config\Jconfig.json") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'Value cannot be empty in ..\config\Jconfig.json';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "Assert exception in $PSCommandPath"
}
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose