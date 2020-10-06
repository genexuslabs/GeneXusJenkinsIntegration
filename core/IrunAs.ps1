param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
### CREATE NEW LOG FILE
if(Test-Path -Path $JLOG)
{ Remove-Item -Path $JLOG }
$noreturn = New-Item -Path $JLOG

Write-Output("== Run at " + (Get-Date -Format G) + " == ") | Tee-Object -FilePath $JLOG -Append -Verbose
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
### CHECK DEPENDENCIES
$Command0 = {& "$ROOT\upkeeper\dependenciesAsserts.ps1" $ROOT $JLOG}
Invoke-Command -ScriptBlock $Command0

### AUTO-UPDATE
$Command1 = {& "$ROOT\upkeeper\syncScripts.ps1" $ROOT $JLOG}
Invoke-Command -ScriptBlock $Command1

### INSTALL DEPENDENCIES AND JENKINS
$Command2 = {& "$ROOT\core\tools\InstallerMan.ps1" $ROOT $JLOG }
try
{
    Invoke-Command -ScriptBlock $Command2
}
catch
{
    Write-Output((Get-Date -Format G) + " ERROR chocolatey internal error") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'chocolatey internal error';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "chocolatey internal error"
}

$Comm001 = {& "$ROOT\config\helpers\reader.ps1" "Jenkins" "path" }
$JENKINS_HOME = Invoke-Command -ScriptBlock $Comm001
$Comm002 = {& "$ROOT\config\helpers\reader.ps1" "Jenkins" "exists" }
$isAlreadyInstalled = Invoke-Command -ScriptBlock $Comm002
if($isAlreadyInstalled.tolower() -eq "false")
{
    $JInstaller = "$ROOT\Core\utils\Installers\JenkinsInstaller.ps1"
    $Command = {& $JInstaller "jenkins" $JLOG $JENKINS_HOME }
    Invoke-Command -ScriptBlock $Command

    ## STARTING JENKINS --WAIT
    Write-Output((Get-Date -Format G) + " INFO starting Jenkins...") | Tee-Object -FilePath $JLOG -Append -Verbose
    for ($i = 1; $i -le 100; $i++ )
    {
        Write-Progress -Activity "Starting Jenkins.." -Status "$i% Complete:" -PercentComplete $i;
        Start-Sleep -Milliseconds 500
    }
    Write-Output((Get-Date -Format G) + " INFO not found JENKINS_HOME") | Tee-Object -FilePath $JLOG -Append -Verbose
    $Command3 = {& "$ROOT\upkeeper\JenkinsManager.ps1" $ROOT $JLOG}
    Invoke-Command -ScriptBlock $Command3
}
else
{
    if($isAlreadyInstalled.tolower() -eq "true") {
        Write-Output((Get-Date -Format G) + " INFO read JENKINS_HOME=$JENKINS_HOME") | Tee-Object -FilePath $JLOG -Append -Verbose
        Write-Output((Get-Date -Format G) + " INFO automatic exec IIrun") | Tee-Object -FilePath $JLOG -Append -Verbose
        $CommIIrun = {& "$ROOT\core\IIrunAs.ps1" $ROOT $JLOG}
        Invoke-Command -ScriptBlock $CommIIrun
    }
    else{
        Write-Output((Get-Date -Format G) + " ERROR unespected flag name in Jenkins.exists") | Tee-Object -FilePath $JLOG -Append -Verbose
        Write-Host -NoNewLine 'unespected flag name in Jenkins.exists';
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
        throw "unespected flag name in Jenkins.exists"
    }
}
### COPY LOG TO JENKINS_HOME
Write-Output((Get-Date -Format G) + " INFO Creating jenkins.log") | Tee-Object -FilePath $JLOG -Append -Verbose
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
Write-Output("== End at " + (Get-Date -Format G) + " == ") | Tee-Object -FilePath $JLOG -Append -Verbose
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
