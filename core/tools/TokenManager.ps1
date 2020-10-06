param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
$Reader = "$ROOT\config\helpers\reader.ps1"
$MetaReader = "$ROOT\keys\helpers\HSreader.ps1"
#### TOKEN: GitHub 
$Comm_0 = {& $MetaReader "GitHub" "token" }
$Gtoken = Invoke-Command -ScriptBlock $Comm_0
Write-Output((Get-Date -Format G) + " INFO read GitHub.token=$Gtoken") | Tee-Object -FilePath $JLOG -Append -Verbose
if($Gtoken.length -gt 2)
{
    Write-Output((Get-Date -Format G) + " INFO GitHub token already set") | Tee-Object -FilePath $JLOG -Append -Verbose
}
else {
    ### READ CREDENTIALS
    $Command_0 = {& $Reader "GitHub" "user" $isDebug }
    $Guser = Invoke-Command -ScriptBlock $Command_0
    Write-Output((Get-Date -Format G) + " INFO read GitHub.user=$Guser") | Tee-Object -FilePath $JLOG -Append -Verbose
    $Command_1 = {& $Reader "GitHub" "pass" $isDebug }
    $Gpass = Invoke-Command -ScriptBlock $Command_1
    Write-Output((Get-Date -Format G) + " INFO read GitHub.pass=********") | Tee-Object -FilePath $JLOG -Append -Verbose

    if([string]::IsNullOrEmpty($Guser) -or [string]::IsNullOrEmpty($Gpass))
    {
        Write-Output((Get-Date -Format G) + " ERROR missing GitHub credentials in Jconfig.json") | Tee-Object -FilePath $JLOG -Append -Verbose
        Write-Host -NoNewLine 'missing GitHub credentials in Jconfig.json';
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
        throw "GITHUB USER OR PASSWORD MISSING IN Jconfig.json"
    }
    else {
        ### GENERATE TOKEN
        $Command_2 = {& "$ROOT\Core\tools\TokenOperator.ps1" $ROOT $JLOG "GitHub" $Guser $Gpass }
        $noret1 = Invoke-Command -ScriptBlock $Command_2        
    }
}

#### GXServer STEP
$Comm_1 = {& $MetaReader "GXServer" "token" }
$GXStoken = Invoke-Command -ScriptBlock $Comm_1
Write-Output((Get-Date -Format G) + " INFO read GXServer.token=$GXStoken") | Tee-Object -FilePath $JLOG -Append -Verbose

if($GXStoken.length -gt 2)
{
    Write-Output((Get-Date -Format G) + " INFO GXServer token already set") | Tee-Object -FilePath $JLOG -Append -Verbose
}
else {
    ### READ
    $Command_00 = {& $Reader "GXServer" "user" $isDebug }
    $GXSuser = Invoke-Command -ScriptBlock $Command_00
    Write-Output((Get-Date -Format G) + " INFO read GXServer.user=$GXSuser") | Tee-Object -FilePath $JLOG -Append -Verbose
    $Command_01 = {& $Reader "GXServer" "pass" $isDebug }
    $GXSpass = Invoke-Command -ScriptBlock $Command_01
    Write-Output((Get-Date -Format G) + " INFO read GXServer.pass=********") | Tee-Object -FilePath $JLOG -Append -Verbose

    if([string]::IsNullOrEmpty($GXSuser) -or [string]::IsNullOrEmpty($GXSpass))
    {
        Write-Output((Get-Date -Format G) + " ERROR missing GXServer credentials in Jconfig.json") | Tee-Object -FilePath $JLOG -Append -Verbose
        Write-Host -NoNewLine 'missing GXServer credentials in Jconfig.json';
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
        throw "GXSERVER USER OR PASSWORD MISSING IN Jconfig.json"
    }
    else {
        ### GENERATE TOKEN
        $Command_02 = {& "$ROOT\core\tools\TokenOperator.ps1" $ROOT $JLOG "GXServer" "$GXSuser" "$GXSpass" }
        $noret2 = Invoke-Command -ScriptBlock $Command_02        
    }
}
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#