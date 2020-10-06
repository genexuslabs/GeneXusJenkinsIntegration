    
param (
    [string] $ROOT = "D:\GitHub\JenkinsForGXServer",    
    [string] $JLOG = "D:\GitHub\JenkinsForGXServer\jenkins.log"
)
$filePath = "$ROOT\resources\templates\org.jenkinsci.plugins.genexus.GeneXusInstallation.xml"
if(Test-Path -Path $filePath)
{
    #### READ
        $Command_1 = {& "$ROOT\config\helpers\reader.ps1" "Jenkins" "path" }
        $JENKINS_HOME = Invoke-Command -ScriptBlock $Command_1
        Write-Output((Get-Date -Format G) + " INFO read JENKINS_HOME=$JENKINS_HOME") | Tee-Object -FilePath $JLOG -Append -Verbose
        $Command_2 = {& "$ROOT\keys\helpers\HSreader.ps1" "MSBuild" "name" }
        $MSBUILD_NAME = Invoke-Command -ScriptBlock $Command_2
        Write-Output((Get-Date -Format G) + " INFO read MSBUILD_NAME=$MSBUILD_NAME") | Tee-Object -FilePath $JLOG -Append -Verbose
        $Command_3 = {& "$ROOT\keys\helpers\HSreader.ps1" "MSBuild" "path" }
        $MSBUILD_PATH = Invoke-Command -ScriptBlock $Command_3
        Write-Output((Get-Date -Format G) + " INFO read MSBUILD_PATH=$MSBUILD_PATH") | Tee-Object -FilePath $JLOG -Append -Verbose
        ## GX read
        $Command_token = {& "$ROOT\Config\helpers\readerGXInstallations.ps1" "GeneXus" }
        $GXs = Invoke-Command -ScriptBlock $Command_token
    ## END READ
    $hudsonFilePath = "$JENKINS_HOME\org.jenkinsci.plugins.genexus.GeneXusInstallation.xml"
    if(Test-Path -Path $hudsonFilePath)
    {
        ##sincronizo
        Write-Output((Get-Date -Format G) + " INFO sync GX installations in existing file") | Tee-Object -FilePath $JLOG -Append -Verbose
        [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "1.1-*","1.0"}
        [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "org.jenkinsci.plugins.genexus.GeneXusInstallation_-DescriptorImpl","ssonhhud"}
        $xmlfile.Save($hudsonFilePath)
        [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "org.jenkinsci.plugins.genexus.GeneXusInstallation","hhudson"}
        $xmlfile.Save($hudsonFilePath)
        $Installations = $xmlfile.ssonhhud.installations.hhudson
        foreach($GX in $GXs)
        {
            Write-Output((Get-Date -Format G) + " INFO sync GX installations in existing file") | Tee-Object -FilePath $JLOG -Append -Verbose
            $existsThisGX = (1 -eq 0)
            foreach($eGX in $Installations)
            {
                if($eGX.name -eq $GX.name)
                {
                    $existsThisGX = (1 -eq 1)
                    $eGX.home = $GX.path
                    $xmlfile.Save($hudsonFilePath)
                    if([string]::IsNullOrEmpty($GX.GXaccount) -or [string]::IsNullOrEmpty($GX.GXpass))
                    {
                        Write-Output((Get-Date -Format G) + " WARNING not found Deploy To Cloud credentials") | Tee-Object -FilePath $JLOG -Append -Verbose
                    }
                    else
                    {
                        $Comm = {& "$ROOT\Core\tools\CredentialOperator.ps1" $ROOT $JLOG $MSBUILD_PATH $GX.path $GX.GXaccount $GX.GXpass  }
                        Invoke-Command -ScriptBlock $Comm 
                    }
                    Write-Output((Get-Date -Format G) + " INFO updating " + $GX.name + " installation") | Tee-Object -FilePath $JLOG -Append -Verbose
                }
            }
            if(-not($existsThisGX))
            {
                Write-Output((Get-Date -Format G) + " INFO adding " + $GX.name + " installation") | Tee-Object -FilePath $JLOG -Append -Verbose
                $baseItem = $xmlfile.CreateElement("hhuddson")
                $null = $xmlfile.ssonhhud.Installations.AppendChild($baseItem)
                $xmlfile.Save($hudsonFilePath)
                $newSubItem1 = $xmlfile.CreateElement("name")
                $newSubItem1.PsBase.InnerText = $GX.name
                $null = $xmlfile.ssonhhud.installations["hhuddson"].AppendChild($newSubItem1)
                $newSubItem2 = $xmlfile.CreateElement("home")
                $newSubItem2.PsBase.InnerText = $GX.path
                $null = $xmlfile.ssonhhud.Installations["hhuddson"].AppendChild($newSubItem2)
                $newSubItem3 = $xmlfile.CreateElement("msBuildInstallationId")
                $newSubItem3.PsBase.InnerText = $MSBUILD_NAME
                $null = $xmlfile.ssonhhud.Installations["hhuddson"].AppendChild($newSubItem3)
                $xmlfile.Save($hudsonFilePath)
                [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "hhuddson","hhudson"}
                $xmlfile.Save($hudsonFilePath)
                if([string]::IsNullOrEmpty($GX.GXaccount) -or [string]::IsNullOrEmpty($GX.GXpass))
                {
                    Write-Output((Get-Date -Format G) + " WARNING not found Deploy To Cloud credentials") | Tee-Object -FilePath $JLOG -Append -Verbose
                }
                else
                {
                    $Comm = {& "$ROOT\Core\tools\CredentialOperator.ps1" $ROOT $JLOG $MSBUILD_PATH $GX.path $GX.GXaccount $GX.GXpass  }
                    Invoke-Command -ScriptBlock $Comm 
                }
            }
        }
        [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "ssonhhud", "org.jenkinsci.plugins.genexus.GeneXusInstallation_-DescriptorImpl"}
        $xmlfile.Save($hudsonFilePath)
        [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "hhudson", "org.jenkinsci.plugins.genexus.GeneXusInstallation"}
        $xmlfile.Save($hudsonFilePath)
    }
    else
    {
        #### XCOPY
        Write-Output((Get-Date -Format G) + " INFO xcopy org.jenkinsci.plugins.genexus.GeneXusInstallation.xml") | Tee-Object -FilePath $JLOG -Append -Verbose
        xcopy.exe $filePath $JENKINS_HOME /Y
        
        Write-Output((Get-Date -Format G) + " INFO editting GX Installations data in new file") | Tee-Object -FilePath $JLOG -Append -Verbose
        [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "1.1-*","1.0"}
        $xmlfile.Save($filePath)
        #### EDIT XML        
        $count = 0
        foreach($GX in $GXs)
        {
            $count +=1
            $constantName = "$count-hud22222on"
            $baseItem = $xmlfile.CreateElement($constantName)
            $null = $xmlfile.hhudson.Installations.AppendChild($baseItem)
            $newSubItem1 = $xmlfile.CreateElement("name")
            $newSubItem1.PsBase.InnerText = $GX.name
            $null = $xmlfile.hhudson.installations[$constantName].AppendChild($newSubItem1)
            $newSubItem2 = $xmlfile.CreateElement("home")
            $newSubItem2.PsBase.InnerText = $GX.path
            $null = $xmlfile.hhudson.Installations[$constantName].AppendChild($newSubItem2)
            $newSubItem3 = $xmlfile.CreateElement("msBuildInstallationId")
            $newSubItem3.PsBase.InnerText = $MSBUILD_NAME
            $null = $xmlfile.hhudson.Installations[$constantName].AppendChild($newSubItem3)
            $xmlfile.Save($hudsonFilePath)
            [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace $constantName,"org.jenkinsci.plugins.genexus.GeneXusInstallation"}
            $xmlfile.Save($hudsonFilePath)

            if([string]::IsNullOrEmpty($GX.GXaccount) -or [string]::IsNullOrEmpty($GX.GXpass))
            {
                Write-Output((Get-Date -Format G) + " WARNING not found Deploy To Cloud credentials") | Tee-Object -FilePath $JLOG -Append -Verbose
            }
            else
            {
                $Comm = {& "$ROOT\Core\tools\CredentialOperator.ps1" $ROOT $JLOG $MSBUILD_PATH $GX.path $GX.GXaccount $GX.GXpass  }
                Invoke-Command -ScriptBlock $Comm 
            }
        }
        [xml]$xmlfile = Get-Content $hudsonFilePath | ForEach-Object{$_ -replace "hhudson","org.jenkinsci.plugins.genexus.GeneXusInstallation_-DescriptorImpl"}
        $xmlfile.Save($hudsonFilePath)
    }
}
else {
    Write-Output((Get-Date -Format G) + " ERROR missing $filePath, core internal error!") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'MISSING $filePath, CORE INTERNAL ERROR!';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "MISSING $filePath, CORE INTERNAL ERROR!"
}