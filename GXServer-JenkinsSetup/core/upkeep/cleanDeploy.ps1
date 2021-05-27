param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path"),
    [bool] $isUninstall = $(throw "isUninstall flag")
)
$Reader = "$ROOT\conf\get\reader.ps1"
$MetaWriter = "$ROOT\keys\helpers\HSwriter.ps1"
$Writer = "$ROOT\conf\set\writer.ps1"
$CollWriter = "$ROOT\conf\set\cleanCollections.ps1"
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
if($isUninstall)
{
    $Command_0 = {& $Reader "Jenkins" "path" }
    $JENKINS_HOME = Invoke-Command -ScriptBlock $Command_0
    Write-Output((Get-Date -Format G) + " INFO read JENKINS_HOME=$JENKINS_HOME")  | Tee-Object -FilePath $JLOG -Append -Verbose

    choco uninstall jenkins -y
    
    if(Test-Path -Path $JENKINS_HOME)
    {
        Write-Output((Get-Date -Format G) + " INFO stopping Jenkins service")  | Tee-Object -FilePath $JLOG -Append -Verbose
        $Command_1 = {& "$ROOT\core\drivers\JenkinsState.ps1" $ROOT "stop"}
        Invoke-Command -ScriptBlock $Command_1
        Start-Sleep -Seconds 8
        
        Write-Output((Get-Date -Format G) + " INFO delete JENKINS_HOME")  | Tee-Object -FilePath $JLOG -Append -Verbose
        Remove-Item -Path $JENKINS_HOME -Force -Recurse
    }
}
Write-Output((Get-Date -Format G) + " INFO write Jcongif.json to null")  | Tee-Object -FilePath $JLOG -Append -Verbose
$Comm_1 = {& $Writer "Jenkins" "path" "" }
Invoke-Command -ScriptBlock $Comm_1
$Comm_2 = {& $Writer "Jenkins" "url" "" }
Invoke-Command -ScriptBlock $Comm_2
$Comm_21 = {& $Writer "Jenkins" "exists" "false" }
Invoke-Command -ScriptBlock $Comm_21
$Comm_3 = {& $Writer "GXaccount" "id" "" }
Invoke-Command -ScriptBlock $Comm_3
$Comm_4 = {& $Writer "GXaccount" "GXuser" "" }
Invoke-Command -ScriptBlock $Comm_4
$Comm_5 = {& $Writer "GXaccount" "GXpass" "" }
Invoke-Command -ScriptBlock $Comm_5
$Comm_6 = {& $Writer "LocalKBPath" "path" "" }
Invoke-Command -ScriptBlock $Comm_6
$Comm_7 = {& $CollWriter $ROOT "SQLCredentials"}
Invoke-Command -ScriptBlock $Comm_7
$Comm_8 = {& $CollWriter $ROOT "GXServerCredentials"}
Invoke-Command -ScriptBlock $Comm_8
$Comm_9 = {& $CollWriter $ROOT "GeneXus"}
Invoke-Command -ScriptBlock $Comm_9

Write-Output((Get-Date -Format G) + " INFO write HSmeta.json to null")  | Tee-Object -FilePath $JLOG -Append -Verbose
$Comm_9 = {& $MetaWriter "MSBuild" "name" "" }
Invoke-Command -ScriptBlock $Comm_9
$Comm_10 = {& $MetaWriter "MSBuild" "path" "" }
Invoke-Command -ScriptBlock $Comm_10

Write-Output((Get-Date -Format G) + " INFO write users.json to null")  | Tee-Object -FilePath $JLOG -Append -Verbose
$Command_token = {& "$ROOT\core\services\helpers\setAdminUser.ps1" "" }
Invoke-Command -ScriptBlock $Command_token

$ReadMePath = "$ROOT\resources\Readme.txt"
if(Test-Path -Path $ReadMePath)
{ Remove-Item $ReadMePath }

Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose