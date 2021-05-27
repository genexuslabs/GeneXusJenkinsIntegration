param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
$Reader = "$ROOT\conf\get\reader.ps1"
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
#### CHECK VALID JSON
$ConfigPath = "$ROOT\conf\Jconfig.json"
try
{
    $jsonrep = Get-Content  $ConfigPath | Out-String | ConvertFrom-Json
    $isValidJson = (1 -eq 0)
}
catch
{
    $isValidJson = (1 -eq 1)
}
if($isValidJson)
{    
    Write-Output((Get-Date -Format G) + " ERROR invalid .json redaction in ..\config\Jconfig.json") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'invalid .json redaction in ..\config\Jconfig.json';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "Assert exception in $PSCommandPath"
}

#### CHECK VALUES
$check = {& "$ROOT\conf\jsonValidator.ps1" $ROOT $JLOG}
$isChecked = Invoke-Command -ScriptBlock $check
if($isChecked -eq 1)
{    
    Write-Output((Get-Date -Format G) + " ERROR Value cannot be empty in ..\conf\Jconfig.json") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'Value cannot be empty in ..\conf\Jconfig.json';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "Assert exception in $PSCommandPath"
}

#### CHECK JENKINS PATH
$Command_1 = {&$Reader "Jenkins" "path" }
$JENKINS_PATH = Invoke-Command -ScriptBlock $Command_1
if(-not ([string]::IsNullOrEmpty($JENKINS_PATH)))
{
    $parts = Split-Path -Path $JENKINS_PATH
    #$parts
    $validPath = 1
    if(Test-Path -Path $parts)
    {
        $validPath = 0
    }
}
if($validPath -eq 1)
{
    Write-Output((Get-Date -Format G) + " ERROR invalid path <$parts>") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine ' invalid path <$parts> (from $JENKINS_PATH)';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "Assert exception in $PSCommandPath"
}

#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose