param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
##
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
$Reader = "$ROOT\config\helpers\reader.ps1"
# READ JENKINS_HOME
$Comm = {& $Reader "Jenkins" "path" }
$JENKINS_HOME = Invoke-Command -ScriptBlock $Comm
Write-Output((Get-Date -Format G) + " INFO read JENKINS_HOME=$JENKINS_HOME") | Tee-Object -FilePath $JLOG -Append -Verbose

### INSTALL ALL NECESARY PLUGINS
$Command0 = {& "$ROOT\core\tools\PluginMan.ps1" $ROOT $JLOG}
Invoke-Command -ScriptBlock $Command0

### CONFIG MSBUILD
$Command1 = {& "$ROOT\Core\utils\MSBuildConfigurator.ps1" $ROOT $JLOG}
Invoke-Command -ScriptBlock $Command1

### CONFIG GENEXUS
$Command2 = {& "$ROOT\core\utils\GXblConfigurator.ps1" $ROOT $JLOG}
Invoke-Command -ScriptBlock $Command2

### CONFIG GENEXUS
$Command3 = {& "$ROOT\core\utils\CustomToolsConfigurator.ps1" $ROOT $JLOG $JENKINS_HOME}
Invoke-Command -ScriptBlock $Command3

### CREATE OPERATOR USER
$Command4 = {& "$ROOT\core\utils\BornOperator.ps1" $ROOT $JLOG}
Invoke-Command -ScriptBlock $Command4

### RESTART JENKINS (enable new user for future requests)
$Command5 = {& "$ROOT\core\drivers\JenkinsState.ps1" $ROOT "restart"}
Invoke-Command -ScriptBlock $Command5
Write-Output((Get-Date -Format G) + " INFO restarting Jenkins...") | Tee-Object -FilePath $JLOG -Append -Verbose

for ($i = 1; $i -le 100; $i++ )
{
    Write-Progress -Activity "Restarting Jenkins.." -Status "$i% Complete:" -PercentComplete $i;
    Start-Sleep -Seconds 1
}

### GET/SET TOKENS
$Command6 = {& "$ROOT\core\tools\TokenManager.ps1" $ROOT $JLOG}
Invoke-Command -ScriptBlock $Command6

### INSTALL LocalSettings.xml
$Command7 = {& "$ROOT\core\utils\SyncLocalSettings.ps1" $ROOT $JLOG $JENKINS_HOME}
Invoke-Command -ScriptBlock $Command7

### CONFIGURE GXServer
$Command8 = {& "$ROOT\upkeeper\GXServerManager.ps1" $ROOT $JLOG}
Invoke-Command -ScriptBlock $Command8

#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#


