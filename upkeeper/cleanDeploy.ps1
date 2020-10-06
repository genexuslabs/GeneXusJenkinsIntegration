param (
    [string] $ROOT = $(throw "miss script root"),
    [string] $isDebug,
    [string] $isForced
)
$JLOG = "$ROOT\jenkins.log"
if ($isDebug) { Write-Output("IN: $PSCommandPath at: " + (Get-Date -Format G)) }
if ($isDebug) { Write-Output("INPUT: $ROOT ")}
if(![string]::IsNullOrEmpty($isForced))
{
    if ($isDebug) { Write-Output("IS FORCED!!!!!!!")}
    $FORCE = [System.Convert]::ToBoolean($isForced)
}
#
$MetaReader = "$ROOT\keys\helpers\HSreader.ps1"
$Reader = "$ROOT\config\helpers\reader.ps1"
$MetaWriter = "$ROOT\keys\helpers\HSwriter.ps1"
$Writer = "$ROOT\config\helpers\writer.ps1"

### uninstall Jenkins
if($FORCE)
{
    ## STOP Jenkins Service
    $Command = {& "$ROOT\core\drivers\JenkinsState.ps1" $ROOT "stop"}
    Invoke-Command -ScriptBlock $Command
    if ($isDebug) { Write-Output("STOP Jenkins..")}
    if ($isDebug) { Write-Output("Forced Uninstalling Jenkins..")}
    powershell.exe choco uninstall Jenkins -y #--no-progress
    
    $Command_1 = {& $Reader "Jenkins" "path" }
    $JENKINS_HOME = Invoke-Command -ScriptBlock $Command_1
    if ($isDebug) { Write-Output("Reader read JENKINS_HOME=$JENKINS_HOME")}
    if(Test-Path -Path $JENKINS_HOME)
    {
        Remove-Item -Path $JENKINS_HOME -Force -Recurse
    }
}

if ($isDebug) { Write-Output("Writer write Jenkins.path=null") }
$Comm_1 = {& $Writer "Jenkins" "path" "" }
Invoke-Command -ScriptBlock $Comm_1

if ($isDebug) { Write-Output("Writer write Jenkins.url=null") }
$Comm_2 = {& $Writer "Jenkins" "url" "" }
Invoke-Command -ScriptBlock $Comm_2

if ($isDebug) { Write-Output("Writer write MSBuild.name=null") }
$Comm_3 = {& $MetaWriter "MSBuild" "name" "" }
Invoke-Command -ScriptBlock $Comm_3

if ($isDebug) { Write-Output("Writer write MSBuild.path=null") }
$Comm_4 = {& $MetaWriter "MSBuild" "path" "" }
Invoke-Command -ScriptBlock $Comm_4

if ($isDebug) { Write-Output("Writer write GitHub.token=null") }
$Comm_4 = {& $MetaWriter "GitHub" "token" "" }
Invoke-Command -ScriptBlock $Comm_4

if ($isDebug) { Write-Output("Writer write GXServer.token=null") }
$Comm_4 = {& $MetaWriter "GXServer" "token" "" }
Invoke-Command -ScriptBlock $Comm_4

$SetAdminToken = "$ROOT\Core\services\helpers\setAdminUser.ps1"
$Command_token = {& $SetAdminToken "" }
Invoke-Command -ScriptBlock $Command_token

if($FORCE)
{
    if ($isDebug) { Write-Output("Deleting user parameters...")}
    $Writer = "$ROOT\config\helpers\writer.ps1"
    $FCommand_0 = {& $Writer "GitHub" "user" "" }
    Invoke-Command -ScriptBlock $FCommand_0
    $FCommand_1 = {& $Writer "GitHub" "pass" "" }
    Invoke-Command -ScriptBlock $FCommand_1
    $FCommand_2 = {& $Writer "GXServer" "url" "" }
    Invoke-Command -ScriptBlock $FCommand_2
    $FCommand_3 = {& $Writer "GXServer" "user" "" }
    Invoke-Command -ScriptBlock $FCommand_3
    $FCommand_4 = {& $Writer "GXServer" "pass" "" }
    Invoke-Command -ScriptBlock $FCommand_4

    $ReadMePath = "$ROOT\resources\Readme.txt"
    if(Test-Path -Path $ReadMePath)
    { Remove-Item $ReadMePath }

    $WRITE = "$ROOT\resources\helpers\WriteProjectTag.ps1"
    $WWComm1 = {& $WRITE $ROOT "Jurl" ""} #PROVIDERurl
    Invoke-Command -ScriptBlock $WWComm1
    $WWComm2 = {& $WRITE $ROOT "username" ""} #PROVIDERusername
    Invoke-Command -ScriptBlock $WWComm2
    $WWComm3 = {& $WRITE $ROOT "usertoken" ""} #PROVIDERtoken
    Invoke-Command -ScriptBlock $WWComm3
    $WWComm4 = {& $WRITE $ROOT "GXSurl" ""} ############## GXSERVER URL
    Invoke-Command -ScriptBlock $WWComm4
    $WWComm5 = {& $WRITE $ROOT "GXStoken" ""} ############ GXSERVER TOKEN
    Invoke-Command -ScriptBlock $WWComm5
    $WWComm6 = {& $WRITE $ROOT "localPath" ""} ######### LOCAL KB PATH
    Invoke-Command -ScriptBlock $WWComm6
    $WWComm7 = {& $WRITE $ROOT "GXname" ""} ############## GENEXUS NAME
    Invoke-Command -ScriptBlock $WWComm7
    $WWComm8 = {& $WRITE $ROOT "msbuildname" ""} ######### MSBUILD NAME
    Invoke-Command -ScriptBlock $WWComm8
    $WWComm9 = {& $WRITE $ROOT "localKbPath" ""} ############## SQL SERVER
    Invoke-Command -ScriptBlock $WWComm9
    $WWComm10 = {& $WRITE $ROOT "localSettings" ""} ############# LOCAL SETTING PATH
    Invoke-Command -ScriptBlock $WWComm10
    $WWComm11 = {& $WRITE $ROOT "gittoken" $GITtoken $isDebug} ########### GIT CREDENTIALS
    Invoke-Command -ScriptBlock $WWComm11

    $Package = "$ROOT\Core\utils\SkipJenkinsSetup\node_modules"
    if(Test-Path -Path $Package)
    { Remove-Item -Path $Package -Recurse -Force }
    $PackageFile = "$ROOT\Core\utils\SkipJenkinsSetup\package-lock.json"
    if(Test-Path -Path $PackageFile)
    { Remove-Item -Path $PackageFile -Force}
    $LogFile = "$ROOT\jenkins.log"
    if(Test-Path -Path $LogFile)
    { Remove-Item -Path $LogFile -Force}
}
#
if ($isDebug) { Write-Output("OUT: $PSCommandPath at: " + (Get-Date -Format G)) }