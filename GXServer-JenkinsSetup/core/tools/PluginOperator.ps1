param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path"),
    [string] $PluginName = $(throw "missing plugin to install"),
    [string] $JENKINS_URL = $(throw "missing JENKINS_URL")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
$MetaReader = "$ROOT\keys\helpers\HSreader.ps1"

Write-Output((Get-Date -Format G) + " INFO Installing $PluginName ...") | Tee-Object -FilePath $JLOG -Append -Verbose
Write-Output((Get-Date -Format G) + " INFO creating XML with plugin info...") | Tee-Object -FilePath $JLOG -Append -Verbose
$filename = "$ROOT\core\services\templates\plugin.xml"
if(Test-Path -Path $filename)
{ Remove-Item -Path $filename }
## CREATE XML
[xml] $pluginXML = New-Object System.Xml.XmlDocument
$noret = $pluginXML.CreateXmlDeclaration("1.0","UTF-8",$null)
$item = $pluginXML.CreateElement("jenkins");
$noret_1 = $pluginXML.AppendChild($item);
$new_node = $pluginXML.CreateElement("install");
$nameAtt_b = $pluginXML.CreateAttribute("plugin");
$nameAtt_b.psbase.value="$PluginName@current";
$noret_2 = $new_node.SetAttributeNode($nameAtt_b);
$pluginXML["jenkins"].AppendChild($new_node)
$pluginXML.Save($fileName)

## READ ADMIN USER 
$Command_1 = {& "$ROOT\core\services\helpers\getAdminUser.ps1" }
$ADMIN = Invoke-Command -ScriptBlock $Command_1
#$ADMIN[0]
#$ADMIN[1]

## CONSTANTS PATH
$COOKIE_PATH = "$ROOT\core\services\templates\cookie"
$CRUMB_PATH = "$ROOT\core\services\templates\crumb.json"

#### CREATE CRUMB FOR ADMIN USER
Write-Output((Get-Date -Format G) + " RUN crumb generator") | Tee-Object -FilePath $JLOG -Append -Verbose
$crumbGenerator = "$ROOT\core\services\web\enableCrumbIssuer.bat" 
$xcomm = {& cmd.exe /c $crumbGenerator $COOKIE_PATH $ADMIN[0] $ADMIN[1] $JENKINS_URL $CRUMB_PATH}
$null = Invoke-Command -ScriptBlock $xcomm
Start-Sleep -Seconds 1
#### READ GENERATED CRUMB
$Command = {& "$ROOT\core\services\helpers\crumbReader.ps1"}
$crumb = Invoke-Command -ScriptBlock $Command
Write-Output((Get-Date -Format G) + " INFO Reader read crumb=$crumb") | Tee-Object -FilePath $JLOG -Append -Verbose
Start-Sleep -Seconds 1
if([string]::IsNullOrEmpty($crumb))
{
    Write-Output((Get-Date -Format G) + " ERROR invalid crumb requested") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'invalid crumb requested';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "EMPTY CRUMB, EXECUTE AGAIN!! (PluginOperator)"
}
else {
    Write-Output((Get-Date -Format G) + " RUN api-rest: /installNecessaryPlugins") | Tee-Object -FilePath $JLOG -Append -Verbose
    try
    {
        $InstallPlugin = "$ROOT\core\services\web\installNecessaryPlugins.bat"
        $vcomm = {& cmd.exe /c $InstallPlugin $COOKIE_PATH $ADMIN[0] $ADMIN[1] $crumb $filename $JENKINS_URL}
        $null = Invoke-Command -ScriptBlock $vcomm
        Start-Sleep -Seconds 1
    }
    catch
    {
        Write-Output((Get-Date -Format G) + " ERROR unable to install $PluginName by Jenkins-api-rest") | Tee-Object -FilePath $JLOG -Append -Verbose
    }
}
Write-Output((Get-Date -Format G) + " INFO remove Session state files") | Tee-Object -FilePath $JLOG -Append -Verbose
Remove-Item -Path $filename -Force
Remove-Item -Path $COOKIE_PATH -Force
Remove-Item -Path $CRUMB_PATH -Force
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#