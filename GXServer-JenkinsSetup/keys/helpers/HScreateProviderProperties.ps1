param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
$MetaReader = "$ROOT\keys\helpers\HSreader.ps1"
#### CREATE Readme file
$InitialFile = "$ROOT\resources\ProviderProperties.txt"
if(Test-Path -Path $InitialFile)
{ Remove-Item -Path $InitialFile }
$null = New-Item -Path $InitialFile
#### READ
$Command_token = {& "$ROOT\conf\get\readerCollection.ps1" "GXServerCredentials" }
$GXSs = Invoke-Command -ScriptBlock $Command_token
$concatGXSs = "<--"
foreach($GXS in $GXSs){
    if(![string]::IsNullOrEmpty($GXS.id))
    {
        $concatGXSs += $GXS.id + "----"
    }
}
$concatGXSs += ">"
#### READ
$Command_token = {& "$ROOT\conf\get\readerCollection.ps1" "GeneXus" }
$GXs = Invoke-Command -ScriptBlock $Command_token
$concatGXs = "<--"
foreach($GX in $GXs){
    if(![string]::IsNullOrEmpty($GX.name))
    {
        $concatGXs += $GX.name + "----"
    }
}
$concatGXs += ">"
#### READ
$Command_1 = {& $MetaReader "MSBuild" "name" }
$MSBUILD_NAME = Invoke-Command -ScriptBlock $Command_1
$concatMSBUILD = "<--$MSBUILD_NAME-->"
#### READ
$Command_token = {& "$ROOT\conf\get\readerCollection.ps1" "SQLCredentials" }
$SQLs = Invoke-Command -ScriptBlock $Command_token
$concatSQLs = "<--"
foreach($SQL in $SQLs){
    if(![string]::IsNullOrEmpty($SQL.id))
    {
        $concatSQLs += $SQL.id + "----"
    }
}
$concatSQLs += ">"
###
Add-Content -Path $InitialFile -Value "PROVIDER CONFIGURATION"
Add-Content -Path $InitialFile -Value "--------------------------------------------------------------------------------------------"
Add-Content -Path $InitialFile -Value "Jenkins connection info"
Add-Content -Path $InitialFile -Value "  - URL: Jenkins url (e.g. http://localhost:8080/)"
Add-Content -Path $InitialFile -Value "  - User Name: Jenkins username with which the token was created:
https://wiki.genexus.com/commwiki/servlet/wiki?47005,How+to+configure+credentials+to+work+with+CI+pipelines#Obtain+token+for+GeneXus+Server"
Add-Content -Path $InitialFile -Value "  - User Token: Token generated in Jenkins for that user"
Add-Content -Path $InitialFile -Value ""
Add-Content -Path $InitialFile -Value "Jenkins configuration"
Add-Content -Path $InitialFile -Value "  - GXserver URL (as seen from Jenkins): URL of the GeneXus Server, which is accessible from the Jenkins machine."
Add-Content -Path $InitialFile -Value "  - GXserver credentials on Jenkins = GXserverLogin"
Add-Content -Path $InitialFile -Value "  - Pipelines folder: Name with which this GXserver will be identified (among others that could also communicate with Jenkins itself). A folder will be created in Jenkins with this identifier, to create the KBs within it. "
Add-Content -Path $InitialFile -Value ""
Add-Content -Path $InitialFile -Value "Pipelines initial configuration"
Add-Content -Path $InitialFile -Value "  - GeneXus installation: $concatGXs"
Add-Content -Path $InitialFile -Value "  - MSBuild installation: $concatMSBUILD"
Add-Content -Path $InitialFile -Value "  - SQL Server for Knowledge Bases: Instance of SQL Server used on the machine where Jenkins is located for GeneXus KBs."
Add-Content -Path $InitialFile -Value "  - SQL Server credentials on Jenkins = SQLServerLogin"
Add-Content -Path $InitialFile -Value "  - Deploy To Cloud: <true/false>"
Add-Content -Path $InitialFile -Value ""
Add-Content -Path $InitialFile -Value "Pipelines Execution Parameters defaults"
Add-Content -Path $InitialFile -Value "  - Force Rebuild: <true/false>"
Add-Content -Path $InitialFile -Value "  - Run Tests: <true/false>"
Add-Content -Path $InitialFile -Value ""
Add-Content -Path $InitialFile -Value "SAVE"

#### OPEN PROVIDER PROPERTIES FIL
Write-Output((Get-Date -Format G) + " INFO opening generated ProviderProperties.txt") | Tee-Object -FilePath $JLOG -Append -Verbose
$open2 = {& $InitialFile}
Invoke-Command -ScriptBlock $open2
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#