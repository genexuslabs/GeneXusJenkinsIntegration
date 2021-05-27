param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path"),
    [string] $ID = $(throw "missing read header"),
    [string] $USER = $(throw "missing username"),
    [string] $PASS = $(throw "missing password")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
$Reader = "$ROOT\conf\get\reader.ps1"

#### CREATE Credentials.xml
Write-Output((Get-Date -Format G) + " INFO generating XML with credentials info...") | Tee-Object -FilePath $JLOG -Append -Verbose
$filename = "$ROOT\core\services\templates\credential.xml"
if(Test-Path -Path $filename)
{ Remove-Item -Path $filename }
[xml] $credentialsXML = New-Object System.Xml.XmlDocument
$null = $credentialsXML.CreateXmlDeclaration("1.0","UTF-8",$null)
$newXmlEmployeeElement = $credentialsXML.CreateElement("hudson");
$null = $credentialsXML.AppendChild($newXmlEmployeeElement);
$newSubItem1 = $credentialsXML.CreateElement("scope")
$newSubItem1.PsBase.InnerText = "GLOBAL"
$null = $credentialsXML["hudson"].AppendChild($newSubItem1)
$newSubItem2 = $credentialsXML.CreateElement("id")
$newSubItem2.PsBase.InnerText = $ID
$null = $credentialsXML["hudson"].AppendChild($newSubItem2)
$newSubItem3 = $credentialsXML.CreateElement("description")
$newSubItem3.PsBase.InnerText = $USER + "$HEADER credentials"
$null = $credentialsXML["hudson"].AppendChild($newSubItem3)
$newSubItem4 = $credentialsXML.CreateElement("username")
$newSubItem4.PsBase.InnerText = $USER
$null = $credentialsXML["hudson"].AppendChild($newSubItem4)
$newSubItem5 = $credentialsXML.CreateElement("password")
$newSubItem5.PsBase.InnerText = $PASS
$null = $credentialsXML["hudson"].AppendChild($newSubItem5)
$credentialsXML.Save($fileName)
[xml]$credentialsXML = Get-Content $filename | ForEach-Object{$_ -replace "hudson","com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl"}
$credentialsXML.Save($fileName)

### GET ADMIN USER DATA
$Command_1 = {& "$ROOT\core\services\helpers\getAdminUser.ps1" }
$ADMIN = Invoke-Command -ScriptBlock $Command_1
Write-Output((Get-Date -Format G) + " INFO Reader read admin.user= "+ $ADMIN[0]) | Tee-Object -FilePath $JLOG -Append -Verbose
Write-Output((Get-Date -Format G) + " INFO Reader read admin.pass=********") | Tee-Object -FilePath $JLOG -Append -Verbose
#$ADMIN[0]
#$ADMIN[1]

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
$zcomm = {& cmd.exe /c $crumbGenerator $COOKIE_PATH $ADMIN[0] $ADMIN[1] $JENKINS_URL $CRUMB_PATH }
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
    $acomm = {& cmd.exe /c $newTokenComm $COOKIE_PATH $ADMIN[0] $ADMIN[1] $crumb $filename $JENKINS_URL}
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