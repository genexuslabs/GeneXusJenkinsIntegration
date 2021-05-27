param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
$Reader = "$ROOT\conf\get\reader.ps1"

$flag = 0

$Command_0 = {&$Reader "LocalKBPath" "path" }
$Result_0 = Invoke-Command -ScriptBlock $Command_0
if([string]::IsNullOrEmpty($Result_0))
{
    Write-Output("LocalKBPath.path is empty in ..\conf\Jconfig.json") | Tee-Object -FilePath $JLOG -Append -Verbose
    $flag = 1
}
$Command_1 = {&$Reader "Jenkins" "exists" }
$Result_1 = Invoke-Command -ScriptBlock $Command_1
if([string]::IsNullOrEmpty($Result_1))
{
    Write-Output("Jenkins.exists must be false, not empty in ..\conf\Jconfig.json") | Tee-Object -FilePath $JLOG -Append -Verbose
    $flag = 1
}
$Command_2 = {&$Reader "GXaccount" "GXuser" }
$Result_2 = Invoke-Command -ScriptBlock $Command_2
if([string]::IsNullOrEmpty($Result_2))
{
    Write-Output("WARNING GXaccount.user empty in ..\conf\Jconfig.json") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Output("BLOCK Deploy to cloud") | Tee-Object -FilePath $JLOG -Append -Verbose
}
else {
    $Command_21 = {&$Reader "GXaccount" "GXpass" }
    $Result_21 = Invoke-Command -ScriptBlock $Command_21
    if([string]::IsNullOrEmpty($Result_21))
    {
        Write-Output("WARNING GXaccount.pass is empty in ..\conf\Jconfig.json") | Tee-Object -FilePath $JLOG -Append -Verbose
        Write-Output("BLOCK Deploy to cloud") | Tee-Object -FilePath $JLOG -Append -Verbose
    }
}
return $flag