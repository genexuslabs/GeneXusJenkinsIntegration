param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path"),
    [string] $JENKINS_HOME = $(throw "missing JENKINS_HOME"),
    [string] $AdminPassword = $(throw "missing admin password")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
#### CREATE Readme file
$InitialFile = "$ROOT\resources\Readme.txt"
if(Test-Path -Path $InitialFile)
{ Remove-Item -Path $InitialFile }
$null = New-Item -Path $InitialFile
Add-Content -Path $InitialFile -Value "JENKINS SETUP INSTRUCTIONS:"
Add-Content -Path $InitialFile -Value ""
Add-Content -Path $InitialFile -Value "  - In Web, go to URL localhost:8080"
Add-Content -Path $InitialFile -Value ""
Add-Content -Path $InitialFile -Value "  - Unlock Jenkins using:"
Add-Content -Path $InitialFile -Value "                         - admin"
Add-Content -Path $InitialFile -Value "                         - $AdminPassword"
Add-Content -Path $InitialFile -Value ""
Add-Content -Path $InitialFile -Value "  - Select 'Install suggested plugins'"
Add-Content -Path $InitialFile -Value ""
Add-Content -Path $InitialFile -Value "  - Select 'Continue as admin', it is important not to change the user yet"
Add-Content -Path $InitialFile -Value ""
Add-Content -Path $InitialFile -Value "  - Select 'Save and Finish'"
Add-Content -Path $InitialFile -Value ""
Add-Content -Path $InitialFile -Value "*** IMPORTANT NOTE"
Add-Content -Path $InitialFile -Value "When Jenkins is installed, it is running as a Windows service. By default, it is running using the Local System Account user, but if tasks are executed by command line, things are saved related to the user who is connected to the machine. Therefore, if Jenkins service runs with another user it can't find them. For that reason, you need to change the user with which the Jenkins service runs, configuring to run with the same user that is connected to the machine: https://stackoverflow.com/questions/63410442/jenkins-installation-windows-10-service-logon-credentials."
Add-Content -Path $InitialFile -Value ""
Add-Content -Path $InitialFile -Value "  - Execute .\JenkinsSetup.ps1 again to configure the installed Jenkins"
Add-Content -Path $InitialFile -Value ""

#### OPEN INITIAL FILE
Write-Output((Get-Date -Format G) + " INFO opening generated Readme.txt") | Tee-Object -FilePath $JLOG -Append -Verbose
$open = {& $InitialFile}
Invoke-Command -ScriptBlock $open

Write-Output((Get-Date -Format G) + " INFO starting url: http://localhost:8080") | Tee-Object -FilePath $JLOG -Append -Verbose
[Diagnostics.Process]::Start('http://localhost:8080/')
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#