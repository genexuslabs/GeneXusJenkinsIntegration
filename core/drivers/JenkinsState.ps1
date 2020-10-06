param (
    [string] $ROOT = $(throw "miss script root"),
    [string] $state = $(throw "miss Jenkins next state")
)
$Command_1 = {& "$ROOT\config\helpers\reader.ps1" "Jenkins" "path" }
$JENKINS_HOME = Invoke-Command -ScriptBlock $Command_1
$run = $JENKINS_HOME + "\jenkins.exe"
cmd.exe /C $run $state