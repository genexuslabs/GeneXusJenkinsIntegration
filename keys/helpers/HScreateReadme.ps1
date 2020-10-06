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
$noret = New-Item -Path $InitialFile
Add-Content -Path $InitialFile -Value "JENKINS SETUP INSTRUCTIONS:"
Add-Content -Path $InitialFile -Value ""
Add-Content -Path $InitialFile -Value "  - In Web, go to URL localhost:8080"
Add-Content -Path $InitialFile -Value ""
Add-Content -Path $InitialFile -Value "  - Unlock Jenkins using:"
Add-Content -Path $InitialFile -Value "                         - admin"
Add-Content -Path $InitialFile -Value "                         - $AdminPassword"
Add-Content -Path $InitialFile -Value ""
Add-Content -Path $InitialFile -Value "  - Select Install suggested plugins"
Add-Content -Path $InitialFile -Value ""
Add-Content -Path $InitialFile -Value "  - Then no need to create a new user, continue as admin "
Add-Content -Path $InitialFile -Value ""
Add-Content -Path $InitialFile -Value "  - Save and Finish"
Add-Content -Path $InitialFile -Value ""
Add-Content -Path $InitialFile -Value "  - Execute core again to configure the installed Jenkins"
Add-Content -Path $InitialFile -Value ""

#### OPEN INITIAL FILE
Write-Output((Get-Date -Format G) + " INFO opening generated Readme.txt") | Tee-Object -FilePath $JLOG -Append -Verbose
$open = {& $InitialFile}
Invoke-Command -ScriptBlock $open

Write-Output((Get-Date -Format G) + " INFO starting url: http://localhost:8080") | Tee-Object -FilePath $JLOG -Append -Verbose
Start-Process chrome -ArgumentList 'http://localhost:8080/'
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#