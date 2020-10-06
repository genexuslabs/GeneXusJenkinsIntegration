param (
    [string] $ROOT = $(throw "miss script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
$Reader = "$ROOT\config\helpers\reader.ps1"
$MetaReader = "$ROOT\keys\helpers\HSreader.ps1"
$getOper = "$ROOT\core\services\helpers\getOperatorUser.ps1"
$WRITE = "$ROOT\resources\helpers\WriteProjectTag.ps1"
############################################## START READ PROVIDER ############################
## Reader HSmeta.json
######################################################## JENKINS URL
$Comm0 = {& $MetaReader "Jenkins" "url" }
$JENKINS_URL = Invoke-Command -ScriptBlock $Comm0
$Comm00 = {& $MetaReader "Jenkins" "path" }
$JENKINS_HOME = Invoke-Command -ScriptBlock $Comm00
######################################################## OPERATOR NAME/TOKEN
$Comm1 = {& $getOper }
$OPERATOR = Invoke-Command -ScriptBlock $Comm1
Write-Output((Get-Date -Format G) + " INFO read operator.user=$OPERATOR[0]") | Tee-Object -FilePath $JLOG -Append -Verbose
#$OPERATOR[0]
#$OPERATOR[1]
$WWComm1 = {& $WRITE $ROOT "Jurl" $JENKINS_URL} #PROVIDERurl
Invoke-Command -ScriptBlock $WWComm1
$WWComm2 = {& $WRITE $ROOT "username" $OPERATOR[0]} #PROVIDERusername
Invoke-Command -ScriptBlock $WWComm2
$WWComm3 = {& $WRITE $ROOT "usertoken" $OPERATOR[1]} #PROVIDERtoken
Invoke-Command -ScriptBlock $WWComm3
############################################## END READ PROVIDER ############################

############################################## START READ DEFAULTS ############################
## Read GXServer values
######################################################## 
$Comm2 = {& $Reader "GXServer" "url" }
$GXSurl = Invoke-Command -ScriptBlock $Comm2
$WWComm4 = {& $WRITE $ROOT "GXSurl" $GXSurl} ############## GXSERVER URL
Invoke-Command -ScriptBlock $WWComm4
######################################################## 
$Comm3 = {& $MetaReader "GXServer" "token" }
$GXStoken = Invoke-Command -ScriptBlock $Comm3
$WWComm5 = {& $WRITE $ROOT "GXStoken" $GXStoken} ############ GXSERVER TOKEN
Invoke-Command -ScriptBlock $WWComm5
######################################################## 
$Comm4 = {& $Reader "local" "KBpath" }
$KBlocalPath = Invoke-Command -ScriptBlock $Comm4
$WWComm6 = {& $WRITE $ROOT "localPath" $KBlocalPath} ######### LOCAL KB PATH
Invoke-Command -ScriptBlock $WWComm6
######################################################## 
#$Comm5 = {& $Reader "GeneXus" "name" }
#$GXname = Invoke-Command -ScriptBlock $Comm5
#$WWComm7 = {& $WRITE $ROOT "GXname" $GXname} ############## GENEXUS NAME
#Invoke-Command -ScriptBlock $WWComm7
######################################################## 
$Comm6 = {& $MetaReader "MSBuild" "name" }
$MSBuildName = Invoke-Command -ScriptBlock $Comm6
$WWComm8 = {& $WRITE $ROOT "msbuildname" $MSBuildName} ######### MSBUILD NAME
Invoke-Command -ScriptBlock $WWComm8
########################################################
#$Comm7 = {& $Reader "GXServer" "url" $isDebug }
#$GXname = Invoke-Command -ScriptBlock $Comm7
#$WWComm9 = {& $WRITE $ROOT "" $GXname $isDebug} ############## SQL SERVER
#Invoke-Command -ScriptBlock $WWComm9
######################################################## 
$Comm8 = {& $Reader "GeneXus" "path" }
$GXpath = Invoke-Command -ScriptBlock $Comm8
$WWComm10 = {& $WRITE $ROOT "localSettings" "$JENKINS_HOME\CIscripts"} ############# LOCAL SETTING PATH
Invoke-Command -ScriptBlock $WWComm10
######################################################## 
$Comm9 = {& $MetaReader "GitHub" "token" }
$GITtoken = Invoke-Command -ScriptBlock $Comm9
$WWComm11 = {& $WRITE $ROOT "gittoken" $GITtoken} ########### GIT CREDENTIALS
Invoke-Command -ScriptBlock $WWComm11
############################################## END READ DEFAULTS ############################

############################################## CALL GXSERVER WITH project.json
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#