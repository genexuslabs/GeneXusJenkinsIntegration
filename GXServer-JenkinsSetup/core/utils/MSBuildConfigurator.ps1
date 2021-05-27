param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
$MetaReader = "$ROOT\keys\helpers\HSreader.ps1"
$Reader = "$ROOT\conf\get\reader.ps1"

#### SEEKEN SEARCH MSBUILD AND SET IN METADATA
$Comm_1 = {& "$ROOT\keys\seekers\findMSBuild.ps1" $ROOT $JLOG}
Invoke-Command -ScriptBlock $Comm_1

#### READ
$Command_1 = {& $MetaReader "MSBuild" "name" }
$MSBUILD_NAME = Invoke-Command -ScriptBlock $Command_1
Write-Output((Get-Date -Format G) + " INFO read MSBUILD_NAME=$MSBUILD_NAME") | Tee-Object -FilePath $JLOG -Append -Verbose
$Command_2 = {& $MetaReader "MSBuild" "path" }
$MSBUILD_PATH = Invoke-Command -ScriptBlock $Command_2
Write-Output((Get-Date -Format G) + " INFO read MSBUILD_PATH=$MSBUILD_PATH") | Tee-Object -FilePath $JLOG -Append -Verbose
$Command_3 = {& $Reader "Jenkins" "path" }
$JENKINS_HOME = Invoke-Command -ScriptBlock $Command_3
Write-Output((Get-Date -Format G) + " INFO read JENKINS_HOME=$JENKINS_HOME") | Tee-Object -FilePath $JLOG -Append -Verbose

if([string]::IsNullOrEmpty($MSBUILD_NAME) -or [string]::IsNullOrEmpty($MSBUILD_PATH))
{    
    Write-Output((Get-Date -Format G) + " ERROR MSBuild installation not found, fail installing dependencies") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'MSBuild installation not found, fail installing dependencies';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "MSBuild installation not found"
}
else {
    #### CHECK FILE TEMPLATE 
    $filePath = "$ROOT\resources\templates\hudson.plugins.msbuild.MsBuildBuilder.xml"
    if(Test-Path -Path $filePath)
    {
        $hudsonFilePath = "$JENKINS_HOME\hudson.plugins.msbuild.MsBuildBuilder.xml"
        if(Test-Path -Path $hudsonFilePath)
        {
            ##sincronizo
            Write-Output((Get-Date -Format G) + " INFO sync GX installations in existing file") | Tee-Object -FilePath $JLOG -Append -Verbose
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "1.1-*","1.0"}
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "hudson.plugins.msbuild.MsBuildBuilder_-DescriptorImpl","ssonhhud"}
            $xmlfile.Save($hudsonFilePath)
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "hudson.plugins.msbuild.MsBuildInstallation","hhudson"}
            $xmlfile.Save($hudsonFilePath)
            #### EDIT XML
            $Installations = $xmlfile.ssonhhud.installations.hhudson
            #$installations
            $existsMyMSBuild = (1 -eq 0)
            foreach($MSB in $Installations)
            {
                if($MSB.name -eq $MSBUILD_NAME)
                {
                    $existsMyMSBuild = (1 -eq 1)
                    if(-not($MSB.home -eq $MSBUILD_PATH))
                    {
                        Write-Output((Get-Date -Format G) + " INFO update MSBuild path for $MSBUILD_NAME") | Tee-Object -FilePath $JLOG -Append -Verbose
                        $MSB.home = $MSBUILD_PATH
                        $xmlfile.Save($hudsonFilePath)
                        #$xmlfile.ssonhhud.installations.hhudson.ChildNodes.Item(1)."#home" = $MSBUILD_PATH
                    }
                }
            }
            if(-not($existsMyMSBuild))
            {
                Write-Output((Get-Date -Format G) + " INFO adding new MSBuild data") | Tee-Object -FilePath $JLOG -Append -Verbose
                #### Already use msbuild but not mine
                $bigElem = $xmlfile.CreateElement("hhudson")
                $null = $xmlfile.ssonhhud.Installations.AppendChild($bigElem)
                $xmlfile.Save($hudsonFilePath)
                $newSubItem1 = $xmlfile.CreateElement("name")
                $newSubItem1.PsBase.InnerText = $MSBUILD_NAME
                $null = $xmlfile.ssonhhud.Installations["hhudson"].AppendChild($newSubItem1)
                $newSubItem2 = $xmlfile.CreateElement("home")
                $newSubItem2.PsBase.InnerText = $MSBUILD_PATH
                $null = $xmlfile.ssonhhud.Installations["hhudson"].AppendChild($newSubItem2)
                $newSubItem3 = $xmlfile.CreateElement("properties")
                #$newSubItem3.PsBase.InnerText = $
                $null = $xmlfile.ssonhhud.Installations["hhudson"].AppendChild($newSubItem3)
                $xmlfile.Save($hudsonFilePath)
            }
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "ssonhhud", "hudson.plugins.msbuild.MsBuildBuilder_-DescriptorImpl"}
            $xmlfile.Save($hudsonFilePath)
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "hhudson", "hudson.plugins.msbuild.MsBuildInstallation"}
            $xmlfile.Save($hudsonFilePath)
        }
        else
        {
            #### XCOPY
            Write-Output((Get-Date -Format G) + " INFO xcopy hudson.plugins.msbuild.MsBuildBuilder.xml") | Tee-Object -FilePath $JLOG -Append -Verbose
            xcopy.exe $filePath $JENKINS_HOME /Y

            Write-Output((Get-Date -Format G) + " INFO editting MSBuild data in new file") | Tee-Object -FilePath $JLOG -Append -Verbose
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "1.1-*","1.0"}
            $xmlfile.Save($hudsonFilePath)
            #### EDIT XML
            $newSubItem1 = $xmlfile.CreateElement("name")
            $newSubItem1.PsBase.InnerText = $MSBUILD_NAME
            $null = $xmlfile.hudson.Installations["hud2son"].AppendChild($newSubItem1)
            $newSubItem2 = $xmlfile.CreateElement("home")
            $newSubItem2.PsBase.InnerText = $MSBUILD_PATH
            $null = $xmlfile.hudson.Installations["hud2son"].AppendChild($newSubItem2)
            $newSubItem3 = $xmlfile.CreateElement("properties")
            #$newSubItem3.PsBase.InnerText = $
            $null = $xmlfile.hudson.Installations["hud2son"].AppendChild($newSubItem3)
            $xmlfile.Save($hudsonFilePath)
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "hudson","hudson.plugins.msbuild.MsBuildBuilder_-DescriptorImpl"}
            $xmlfile.Save($hudsonFilePath)
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "hud2son","hudson.plugins.msbuild.MsBuildInstallation"}
            $xmlfile.Save($hudsonFilePath)
            #[xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "1.0","1.1"}
            #$xmlfile.Save($hudsonFilePath)
        }
    }
    else {
        Write-Output((Get-Date -Format G) + " ERROR missing $filePath, core internal error!") | Tee-Object -FilePath $JLOG -Append -Verbose
        Write-Host -NoNewLine 'MISSING $filePath, CORE INTERNAL ERROR!';
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
        throw "MISSING $filePath, CORE INTERNAL ERROR!"
    }    
}
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#