param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path"),
    [string] $HEADER = $(throw "missing read header"),
    [string] $USER = $(throw "missing username"),
    [string] $PASS = $(throw "missing password")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
$MetaReader = "$ROOT\keys\helpers\HSreader.ps1"
$Reader = "$ROOT\config\helpers\reader.ps1"
$MetaWriter = "$ROOT\keys\helpers\HSwriter.ps1"

### GENERATE NEW GUID FOR TOKEN-ID
$GUID = [guid]::NewGuid()
Write-Output((Get-Date -Format G) + " INFO write $HEADER.token=$GUID") | Tee-Object -FilePath $JLOG -Append -Verbose
$Comm_1 = {& $MetaWriter $HEADER "token" $GUID }
Invoke-Command -ScriptBlock $Comm_1
#### CREATE Credentials.xml
Write-Output((Get-Date -Format G) + " INFO generating XML with credentials info...") | Tee-Object -FilePath $JLOG -Append -Verbose
$filename = "$ROOT\core\services\templates\credential.xml"
if(Test-Path -Path $filename)
{ Remove-Item -Path $filename }
[xml] $credentialsXML = New-Object System.Xml.XmlDocument
$noret = $credentialsXML.CreateXmlDeclaration("1.0","UTF-8",$null)
$newXmlEmployeeElement = $credentialsXML.CreateElement("hudson");
$newXmlEmployee = $credentialsXML.AppendChild($newXmlEmployeeElement);
$newSubItem1 = $credentialsXML.CreateElement("scope")
$newSubItem1.PsBase.InnerText = "GLOBAL"
$noRet1 = $credentialsXML["hudson"].AppendChild($newSubItem1)
$newSubItem2 = $credentialsXML.CreateElement("id")
$newSubItem2.PsBase.InnerText = $GUID
$noRet2 = $credentialsXML["hudson"].AppendChild($newSubItem2)
$newSubItem3 = $credentialsXML.CreateElement("description")
$newSubItem3.PsBase.InnerText = $USER + "$HEADER credentials"
$noRet3 = $credentialsXML["hudson"].AppendChild($newSubItem3)
$newSubItem4 = $credentialsXML.CreateElement("username")
$newSubItem4.PsBase.InnerText = $USER
$noRet4 = $credentialsXML["hudson"].AppendChild($newSubItem4)
$newSubItem5 = $credentialsXML.CreateElement("password")
$newSubItem5.PsBase.InnerText = $PASS
$noRet5 = $credentialsXML["hudson"].AppendChild($newSubItem5)
$credentialsXML.Save($fileName)
[xml]$credentialsXML = Get-Content $filename | ForEach-Object{$_ -replace "hudson","com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl"}
$credentialsXML.Save($fileName)

### GET OPERATOR USER DATA
$Command_1 = {& "$ROOT\core\services\helpers\getOperatorUser.ps1" }
$OPERATOR = Invoke-Command -ScriptBlock $Command_1
Write-Output((Get-Date -Format G) + " INFO Reader read operator.user=+$OPERATOR[0]") | Tee-Object -FilePath $JLOG -Append -Verbose
Write-Output((Get-Date -Format G) + " INFO Reader read operator.pass=********") | Tee-Object -FilePath $JLOG -Append -Verbose
#$OPERATOR[0]
#$OPERATOR[1]

## READ JENKINS URL
$Command_2 = {& $Reader "Jenkins" "url" }
$JENKINS_URL = Invoke-Command -ScriptBlock $Command_2
Write-Output((Get-Date -Format G) + " INFO Reader read JENKINS_URL=$JENKINS_URL") | Tee-Object -FilePath $JLOG -Append -Verbose

## CONSTANTS
$COOKIE_PATH = "$ROOT\core\services\templates\cookie"
$CRUMB_PATH = "$ROOT\core\services\templates\crumb.json"

## CREATE CRUMB FOR OPERATOR USER
Write-Output((Get-Date -Format G) + " RUN crumb generator") | Tee-Object -FilePath $JLOG -Append -Verbose
$crumbGenerator = "$ROOT\core\services\web\enableCrumbIssuer.bat" 
$zcomm = {& cmd.exe /c $crumbGenerator $COOKIE_PATH $OPERATOR[0] $OPERATOR[1] $JENKINS_URL $CRUMB_PATH }
$null = Invoke-Command -ScriptBlock $zcomm
Start-Sleep -Seconds 1
#### READ GENERATED CRUMB
$Command = {& "$ROOT\core\services\helpers\crumbReader.ps1"}
$crumb = Invoke-Command -ScriptBlock $Command
Write-Output((Get-Date -Format G) + " INFO Reader read crumb=$crumb") | Tee-Object -FilePath $JLOG -Append -Verbose
if([string]::IsNullOrEmpty($crumb))
{
    Write-Output((Get-Date -Format G) + " ERROR empty crumb, execute again!! (TokenOperator)") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'EMPTY CRUMB, EXECUTE AGAIN!! (TokenOperator)';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "EMPTY CRUMB, EXECUTE AGAIN!! (TokenOperator)"
}
else {
    Write-Output((Get-Date -Format G) + " RUN api-rest: /createCredentials...") | Tee-Object -FilePath $JLOG -Append -Verbose
    $newTokenComm = "$ROOT\core\services\web\createNewToken.bat"
    $acomm = {& cmd.exe /c $newTokenComm $COOKIE_PATH $OPERATOR[0] $OPERATOR[1] $crumb $filename $JENKINS_URL}
    $null = Invoke-Command -ScriptBlock $acomm
    
    Write-Output((Get-Date -Format G) + " INFO remove $filename") | Tee-Object -FilePath $JLOG -Append -Verbose
    Remove-Item -Path $filename -Force
    Write-Output((Get-Date -Format G) + " INFO remove $COOKIE_PATH") | Tee-Object -FilePath $JLOG -Append -Verbose
    Remove-Item -Path $COOKIE_PATH -Force
    Write-Output((Get-Date -Format G) + " INFO remove $CRUMB_PATH") | Tee-Object -FilePath $JLOG -Append -Verbose
    Remove-Item -Path $CRUMB_PATH -Force
}
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#