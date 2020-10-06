param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
#### seeker set to HSmeta JENKINS_HOME
$Jseeker = {& "$ROOT\keys\seekers\findJenkins.ps1" $ROOT $JLOG}
$noRet = Invoke-Command -ScriptBlock $Jseeker
#### Search again JENKINS_HOME
$Comm001 = {& "$ROOT\config\helpers\reader.ps1" "Jenkins" "path" }
$JENKINS_HOME = Invoke-Command -ScriptBlock $Comm001
Write-Output((Get-Date -Format G) + " INFO read JENKINS_HOME=$JENKINS_HOME")  | Tee-Object -FilePath $JLOG -Append -Verbose

#### Get admin password token
#### FIND SECRET AND EXPOSE
$Secret = "$JENKINS_HOME\secrets\initialAdminPassword"
if(Test-Path -Path $Secret)
{
    $JSONini = Get-Content -Path $Secret
    $SetAdminToken = "$ROOT\core\services\helpers\setAdminUser.ps1"
    $Flag = (1 -eq 1)
    foreach ($line in $JSONini) {
        if($Flag)
        {
            $Flag = (1 -eq 0)
            Write-Output((Get-Date -Format G) + " INFO write admin.token=$line") | Tee-Object -FilePath $JLOG -Append -Verbose
            $Command_token = {& $SetAdminToken $line }
            $null = Invoke-Command -ScriptBlock $Command_token
            $AdminPass = $line
            Write-Output((Get-Date -Format G) + " INFO write admin.token=$line") | Tee-Object -FilePath $JLOG -Append -Verbose
        }
    }
    #### TRY NPM FEATURE (NOT YET)
    #try 
    #{
        ### call nodemanager
    #    $SkipComm = {& "$ROOT\core\utils\SkipJenkinsSetup\nodeManager.ps1" $ROOT $JLOG}
    #    Invoke-Command -ScriptBlock $SkipComm
    #}
    #catch
    #{
        ### call create readme
        $ManualComm = {& "$ROOT\keys\helpers\HScreateReadme.ps1" $ROOT $JLOG $JENKINS_HOME $AdminPass}
        Invoke-Command -ScriptBlock $ManualComm
    #}
}
else
{
    Write-Output((Get-Date -Format G) + " ERROR missing JENKINS_HOME") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'missing missing JENKINS_HOME';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "missing JENKINS_HOME"
}
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
return $isFirstTimeRun