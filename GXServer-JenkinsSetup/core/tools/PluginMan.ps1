param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
$Reader = "$ROOT\conf\get\reader.ps1"
### READ JENKINS_HOME
$Comm = {& $Reader "Jenkins" "path" }
$JENKINS_HOME = Invoke-Command -ScriptBlock $Comm
Write-Output((Get-Date -Format G) + " INFO read JENKINS_HOME=$JENKINS_HOME") | Tee-Object -FilePath $JLOG -Append -Verbose

### READ JENKINS_URL
$Comm_1 = {& $Reader "Jenkins" "url" }
$JENKINS_URL = Invoke-Command -ScriptBlock $Comm_1
Write-Output((Get-Date -Format G) + " INFO read JENKINS_URL=$JENKINS_URL") | Tee-Object -FilePath $JLOG -Append -Verbose

### INSTALL NECESSARY PLUGINS
$PluginOper = "$ROOT\core\tools\PluginOperator.ps1"
$FilePath = "$ROOT\resources\data\plugins.txt"
$PluginList = Get-Content -Path $FilePath
foreach($PluginName in $PluginList)
{
    $AlreadyInstalled = $JENKINS_HOME+"\plugins\"+$PluginName.ToLower()+".jpi"
    if(Test-Path -Path $AlreadyInstalled)
    {    
        Write-Output((Get-Date -Format G) + " INFO $PluginName is already installed") | Tee-Object -FilePath $JLOG -Append -Verbose
    }
    else
    {
        $Comm = {& $PluginOper $ROOT $JLOG $PluginName $JENKINS_URL}
        Invoke-Command -ScriptBlock $Comm
        Start-Sleep -Seconds 2
    }
}
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#