param (
    [string] $ROOT = $(throw "miss script root"),
    [string] $JLOG = $(throw "missing jenkis.log path"),
    [string] $Steps
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
$MetaReader = "$ROOT\keys\helpers\HSreader.ps1"
#### change location
$auxPath = (get-item $PSScriptRoot).FullName
#$auxPath
Set-Location -Path $auxPath

$Command_1 = {& "$ROOT\core\utils\SkipJenkinsSetup\execNPM.ps1" $ROOT $JLOG }
Invoke-Command -ScriptBlock $Command_1

$Command_2 = {& "$ROOT\core\utils\SkipJenkinsSetup\execNODE.ps1" $ROOT $JLOG }
Invoke-Command -ScriptBlock $Command_2

### READ JENKINS_HOME
$Comm_1 = {& $MetaReader "Jenkins" "path" }
$JENKINS_HOME = Invoke-Command -ScriptBlock $Comm_1
Write-Output((Get-Date -Format G) + " INFO read JENKINS_HOME=$JENKINS_HOME") | Tee-Object -FilePath $JLOG -Append -Verbose

### READ JENKINS_URL
$Comm_2 = {& $MetaReader "Jenkins" "url" }
$JENKINS_URL = Invoke-Command -ScriptBlock $Comm_2
Write-Output((Get-Date -Format G) + " INFO read JENKINS_URL=$JENKINS_URL") | Tee-Object -FilePath $JLOG -Append -Verbose

#### install suggested plugins
$FilePath = "$ROOT\resources\data\externalplugins.txt"
$PluginList = Get-Content -Path $FilePath
$PluginOper = "$ROOT\core\tools\PluginOperator.ps1"
foreach($PluginItemName in $PluginList)
{
    $AlreadyInstalled = $JENKINS_HOME+"\plugins\"+$PluginItemName.ToLower()+".jpi"
    if(Test-Path -Path $AlreadyInstalled)
    {    
        Write-Output((Get-Date -Format G) + " INFO $PluginName is already installed") | Tee-Object -FilePath $JLOG -Append -Verbose
    }
    else
    {
        $Command0 = {& $PluginOper $ROOT $JLOG $PluginItemName $JENKINS_URL}
        Invoke-Command -ScriptBlock $Command0
        Start-Sleep -Seconds 5
    }
}

## Restart Jenkins Service
Write-Output((Get-Date -Format G) + " INFO restarting Jenkins") | Tee-Object -FilePath $JLOG -Append -Verbose
$Comm_3 = {& "$ROOT\core\drivers\JenkinsState.ps1" $ROOT "restart"}
Invoke-Command -ScriptBlock $Comm_3
Write-Host -NoNewLine 'Progress '
for ($i = 0; $i -lt 10; $i++) {
    Start-Sleep -Seconds 2
    Write-Host -NoNewLine '=' 
}
Write-Output(" !!Ready!!") 
#### restore location
Set-Location -Path $ROOT

#### run IIrun
$CommIIrun = {& "$ROOT\core\IIrunAs.ps1" $ROOT $JLOG $Steps}
Invoke-Command -ScriptBlock $CommIIrun
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#