param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path"),
    [string] $JENKINS_HOME = $(throw "missing JENKINS_HOME")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
$Reader = "$ROOT\conf\get\reader.ps1"

#### READ
$Command_1 = {& $Reader "LocalKBPath" "path" }
$LOCAL_PATH = Invoke-Command -ScriptBlock $Command_1
Write-Output((Get-Date -Format G) + " INFO read local.path=$LOCAL_PATH") | Tee-Object -FilePath $JLOG -Append -Verbose

$LOCAL_SCRIPTS_PATH = "$JENKINS_HOME\CIscripts"
if([string]::IsNullOrEmpty($LOCAL_PATH))
{
    Write-Output((Get-Date -Format G) + " ERROR LocalKBPath not found, fail searching installation") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'LocalKBPath not found, fail searching installation';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "UNABLE TO READ LocalKBPath from Jconfig.json!!"
}
else {
#### CHECK FILE TEMPLATE 
    $filePath = "$ROOT\resources\templates\com.cloudbees.jenkins.plugins.customtools.CustomTool.xml"
    if(Test-Path -Path $filePath)
    {
        $hudsonFilePath = "$JENKINS_HOME\com.cloudbees.jenkins.plugins.customtools.CustomTool.xml"
        if(Test-Path -Path $hudsonFilePath)
        { 
            Write-Output((Get-Date -Format G) + " INFO sync custom tools data") | Tee-Object -FilePath $JLOG -Append -Verbose
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "1.1-*","1.0"}
            $xmlfile.Save($hudsonFilePath)
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "com.cloudbees.jenkins.plugins.customtools.CustomTool_-DescriptorImpl", "cclouudbee"}
            $xmlfile.Save($hudsonFilePath)
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "com.cloudbees.jenkins.plugins.customtools.CustomTool", "clouddbbee"}
            $xmlfile.Save($hudsonFilePath)
            $params = $xmlfile.cclouudbee.installations.clouddbbee
            $existsMyCT = (1 -eq 0)
            $existsMyCT2 = (1 -eq 0)
            foreach($CT in $params)
            {
                if($CT.name -eq "DefaultKBPath")
                {
                    $existsMyCT = (1 -eq 1)
                    $CT.home = $LOCAL_PATH
                    $xmlfile.Save($hudsonFilePath)
                    Write-Output((Get-Date -Format G) + " INFO updating custom tools DefaultKBPath data") | Tee-Object -FilePath $JLOG -Append -Verbose
                }
                if($CT.name -eq "CIscripts")
                {
                    $existsMyCT2 = (1 -eq 1)
                    $CT.home = $LOCAL_SCRIPTS_PATH
                    $xmlfile.Save($hudsonFilePath)
                    Write-Output((Get-Date -Format G) + " INFO updating custom tools CIscripts data") | Tee-Object -FilePath $JLOG -Append -Verbose
                }
            }
            if(-not($existsMyCT))
            {
                Write-Output((Get-Date -Format G) + " INFO adding custom tools DefaultKBPath data") | Tee-Object -FilePath $JLOG -Append -Verbose
                $baseItem1 = $xmlfile.CreateElement("cclloouuddbbeeeess")
                $null = $xmlfile.cclouudbee.Installations.AppendChild($baseItem1)
                $xmlfile.Save($hudsonFilePath)

                $newSubItem1 = $xmlfile.CreateElement("name")
                $newSubItem1.PsBase.InnerText = "DefaultKBPath"
                $null = $xmlfile.cclouudbee.installations["cclloouuddbbeeeess"].AppendChild($newSubItem1)
                $newSubItem2 = $xmlfile.CreateElement("home")
                $newSubItem2.PsBase.InnerText = $LOCAL_PATH
                $null = $xmlfile.cclouudbee.Installations["cclloouuddbbeeeess"].AppendChild($newSubItem2)
                $newSubItem3 = $xmlfile.CreateElement("properties")
                #$newSubItem3.PsBase.InnerText = 
                $null = $xmlfile.cclouudbee.Installations["cclloouuddbbeeeess"].AppendChild($newSubItem3)
                $newSubItem4 = $xmlfile.CreateElement("exportedPaths")
                #$newSubItem4.PsBase.InnerText = 
                $null = $xmlfile.cclouudbee.Installations["cclloouuddbbeeeess"].AppendChild($newSubItem4)
                $newSubItem5 = $xmlfile.CreateElement("additionalVariables")
                #$newSubItem5.PsBase.InnerText = 
                $null = $xmlfile.cclouudbee.Installations["cclloouuddbbeeeess"].AppendChild($newSubItem5)
                $xmlfile.Save($hudsonFilePath)
            
                [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "cclloouuddbbeeeess", "clouddbbee"}
                $xmlfile.Save($hudsonFilePath)
            }
            if(-not($existsMyCT2))
            {
                Write-Output((Get-Date -Format G) + " INFO adding custom tools CIscripts data") | Tee-Object -FilePath $JLOG -Append -Verbose
                $baseItem1 = $xmlfile.CreateElement("cclloouuddbbeeeess")
                $null = $xmlfile.cclouudbee.Installations.AppendChild($baseItem1)
                $xmlfile.Save($hudsonFilePath)

                $newSubItem1 = $xmlfile.CreateElement("name")
                $newSubItem1.PsBase.InnerText = "CIscripts"
                $null = $xmlfile.cclouudbee.installations["cclloouuddbbeeeess"].AppendChild($newSubItem1)
                $newSubItem2 = $xmlfile.CreateElement("home")
                $newSubItem12.PsBase.InnerText = $LOCAL_SCRIPTS_PATH
                $null = $xmlfile.cclouudbee.Installations["cclloouuddbbeeeess"].AppendChild($newSubItem2)
                $newSubItem3 = $xmlfile.CreateElement("properties")
                #$newSubItem3.PsBase.InnerText = 
                $null = $xmlfile.cclouudbee.Installations["cclloouuddbbeeeess"].AppendChild($newSubItem3)
                $newSubItem4 = $xmlfile.CreateElement("exportedPaths")
                #$newSubItem4.PsBase.InnerText = 
                $null = $xmlfile.cclouudbee.Installations["cclloouuddbbeeeess"].AppendChild($newSubItem4)
                $newSubItem5 = $xmlfile.CreateElement("additionalVariables")
                #$newSubItem5.PsBase.InnerText = 
                $null = $xmlfile.cclouudbee.Installations["cclloouuddbbeeeess"].AppendChild($newSubItem5)
                $xmlfile.Save($hudsonFilePath)
                
            
                [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "cclloouuddbbeeeess", "clouddbbee"}
                $xmlfile.Save($hudsonFilePath)
            }
            
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "cclouudbee", "com.cloudbees.jenkins.plugins.customtools.CustomTool_-DescriptorImpl"}
            $xmlfile.Save($hudsonFilePath)
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "clouddbbee", "com.cloudbees.jenkins.plugins.customtools.CustomTool"}
            $xmlfile.Save($hudsonFilePath)
        }
        else
        {
            #### XCOPY
            Write-Output((Get-Date -Format G) + " INFO xcopy com.cloudbees.jenkins.plugins.customtools.CustomTool.xml") | Tee-Object -FilePath $JLOG -Append -Verbose
            xcopy.exe $filePath $JENKINS_HOME /Y

            #### EDIT XML        
            Write-Output((Get-Date -Format G) + " INFO editting custom tools data in new file") | Tee-Object -FilePath $JLOG -Append -Verbose
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "1.1-*","1.0"}
            $xmlfile.Save($hudsonFilePath)
            #$xmlfile
            $constantName1 = "cloudbees1"
            $constantName11 = "cloudbees2"
            $baseItem1 = $xmlfile.CreateElement($constantName1)
            $null = $xmlfile.ccloudbees.Installations.AppendChild($baseItem1)

            $newSubItem1 = $xmlfile.CreateElement("name")
            $newSubItem1.PsBase.InnerText = "DefaultKBPath"
            $null = $xmlfile.ccloudbees.installations[$constantName1].AppendChild($newSubItem1)
            $newSubItem2 = $xmlfile.CreateElement("home")
            $newSubItem2.PsBase.InnerText = $LOCAL_PATH
            $null = $xmlfile.ccloudbees.Installations[$constantName1].AppendChild($newSubItem2)
            $newSubItem3 = $xmlfile.CreateElement("properties")
            #$newSubItem3.PsBase.InnerText = 
            $null = $xmlfile.ccloudbees.Installations[$constantName1].AppendChild($newSubItem3)
            $newSubItem4 = $xmlfile.CreateElement("exportedPaths")
            #$newSubItem4.PsBase.InnerText = 
            $null = $xmlfile.ccloudbees.Installations[$constantName1].AppendChild($newSubItem4)
            $newSubItem5 = $xmlfile.CreateElement("additionalVariables")
            #$newSubItem5.PsBase.InnerText = 
            $null = $xmlfile.ccloudbees.Installations[$constantName1].AppendChild($newSubItem5)

            $baseItem11 = $xmlfile.CreateElement($constantName11)
            $null = $xmlfile.ccloudbees.Installations.AppendChild($baseItem11)
            $newSubItem11 = $xmlfile.CreateElement("name")
            $newSubItem11.PsBase.InnerText = "CIscripts"
            $null = $xmlfile.ccloudbees.installations[$constantName11].AppendChild($newSubItem11)
            $newSubItem12 = $xmlfile.CreateElement("home")
            $newSubItem12.PsBase.InnerText = $LOCAL_SCRIPTS_PATH
            $null = $xmlfile.ccloudbees.Installations[$constantName11].AppendChild($newSubItem12)
            $newSubItem13 = $xmlfile.CreateElement("properties")
            #$newSubItem13.PsBase.InnerText = 
            $null = $xmlfile.ccloudbees.Installations[$constantName11].AppendChild($newSubItem13)
            $newSubItem14 = $xmlfile.CreateElement("exportedPaths")
            #$newSubItem14.PsBase.InnerText = 
            $null = $xmlfile.ccloudbees.Installations[$constantName11].AppendChild($newSubItem14)
            $newSubItem15 = $xmlfile.CreateElement("additionalVariables")
            #$newSubItem15.PsBase.InnerText = 
            $null = $xmlfile.ccloudbees.Installations[$constantName11].AppendChild($newSubItem15)

            $xmlfile.Save($hudsonFilePath)
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace $constantName1,"com.cloudbees.jenkins.plugins.customtools.CustomTool"}
            $xmlfile.Save($hudsonFilePath)
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace $constantName11,"com.cloudbees.jenkins.plugins.customtools.CustomTool"}
            $xmlfile.Save($hudsonFilePath)
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "ccloudbees","com.cloudbees.jenkins.plugins.customtools.CustomTool_-DescriptorImpl"}
            $xmlfile.Save($hudsonFilePath)

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
