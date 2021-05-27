param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $state = $(throw "missing Jenkins next state")
)
$Command_1 = {& "$ROOT\conf\get\reader.ps1" "Jenkins" "path" }
$JENKINS_HOME = Invoke-Command -ScriptBlock $Command_1
$run = $JENKINS_HOME + "\jenkins.exe"
cmd.exe /C $run $state