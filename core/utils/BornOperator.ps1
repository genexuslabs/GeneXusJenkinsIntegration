param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
### READ
$Command_0 = {& "$ROOT\config\helpers\reader.ps1" "Jenkins" "path" }
$JENKINS_HOME = Invoke-Command -ScriptBlock $Command_0
Write-Output((Get-Date -Format G) + " INFO read JENKINS_HOME=$JENKINS_HOME") | Tee-Object -FilePath $JLOG -Append -Verbose
if([string]::IsNullOrEmpty($JENKINS_HOME))
{
    Write-Output((Get-Date -Format G) + " ERROR missing JENKINS_HOME") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'missing JENKINS_HOME';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "JENKINS_HOME not set"
}
else {
    $Destination = "$JENKINS_HOME\users"
    $OperatorFolder = "$ROOT\resources\templates\operator_6528843108721941413"

    if(Test-Path -Path "$Destination\operator_6528843108721941413\config.xml")
    {
        Write-Output((Get-Date -Format G) + " INFO already exists operator user") | Tee-Object -FilePath $JLOG -Append -Verbose
    }
    else {
        ### COPY OPERATOR FOLDER
        Write-Output((Get-Date -Format G) + " INFO sync operator user") | Tee-Object -FilePath $JLOG -Append -Verbose
        Copy-Item -Path $OperatorFolder -Destination $Destination -Recurse
        #### CONFIGURE OPERATOR USER.XML
        $filePath = "$JENKINS_HOME\users\users.xml"
        [xml]$usersXML = Get-Content $filePath | ForEach-Object{$_ -replace "1.1-*","1.0"}
        $usersXML.Save($filePath)
        $newSubItem = $usersXML.CreateElement("NEWENTRY")
        $noRet = $usersXML["hudson.model.UserIdMapper"]["idToDirectoryNameMap"].AppendChild($newSubItem)
        $newSubItem2 = $usersXML.CreateElement("string")
        $newSubItem2.PsBase.InnerText = "operator"
        $noRet = $usersXML["hudson.model.UserIdMapper"]["idToDirectoryNameMap"]["NEWENTRY"].AppendChild($newSubItem2)
        $newSubItem3 = $usersXML.CreateElement("string")
        $newSubItem3.PsBase.InnerText = "operator_6528843108721941413"
        $noRet2 = $usersXML["hudson.model.UserIdMapper"]["idToDirectoryNameMap"]["NEWENTRY"].AppendChild($newSubItem3)
        $usersXML.Save($filePath)
        [xml]$usersXML = Get-Content $filePath | ForEach-Object{$_ -replace "NEWENTRY","entry"}
        $usersXML.Save($filePath)
    }
}
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#