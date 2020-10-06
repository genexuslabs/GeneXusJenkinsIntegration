param (
    [string] $ROOT = $(throw "miss script root")
)
$Reader = "$ROOT\config\helpers\reader.ps1"

$flag = 0

if ($isDebug) { Write-Output("INPUT: $ROOT ")}

$Command_0 = {&$Reader "LocalKBPath" "path" }
$Result_0 = Invoke-Command -ScriptBlock $Command_0
if([string]::IsNullOrEmpty($Result_0))
{
    Write-Output("LocalKBPath.path is empty in ..\config\Jconfig.json")
    $flag = 1
}
$Command_1 = {&$Reader "Jenkins" "exists" }
$Result_1 = Invoke-Command -ScriptBlock $Command_1
if([string]::IsNullOrEmpty($Result_1))
{
    Write-Output("Jenkins.exists is empty in ..\config\Jconfig.json")
    $flag = 1
}

$Command_3 = {&$Reader "GXServer" "url" }
$Result_3 = Invoke-Command -ScriptBlock $Command_3
if([string]::IsNullOrEmpty($Result_3))
{
    Write-Output("GXServer.url is empty in ..\config\Jconfig.json")
    $flag = 1
}
$Command_4 = {&$Reader "GXServer" "user" }
$Result_4 = Invoke-Command -ScriptBlock $Command_4
if([string]::IsNullOrEmpty($Result_4))
{
    Write-Output("GXServer.user is empty in ..\config\Jconfig.json")
    $flag = 1
}
$Command_5 = {&$Reader "GXServer" "pass" }
$Result_5 = Invoke-Command -ScriptBlock $Command_5
if([string]::IsNullOrEmpty($Result_5))
{
    Write-Output("GXServer.pass is empty in ..\config\Jconfig.json")
    $flag = 1
}
$Command_6 = {& "$ROOT\Config\helpers\readerOneGX.ps1" "GeneXus" }
$GX = Invoke-Command -ScriptBlock $Command_6
if([string]::IsNullOrEmpty($GX[0]) -or [string]::IsNullOrEmpty($GX[1]))
{
    Write-Output("GeneXus installation is empty in ..\config\Jconfig.json")
    $flag = 1
}
return $flag