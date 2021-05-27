param (
    [string] $param1
)
###
$FilePath = "$PSScriptRoot\jenkins.log"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
###
if([string]::IsNullOrEmpty($param1))
{
    try
    {
        ## Run as administrator
        $aux = "$PSScriptRoot\core\IrunAs.ps1 $PSScriptRoot $FilePath"
        Start-Process "powershell.exe" -ArgumentList $aux -Verb RunAs
    }
    catch
    {
        Write-Output($_)
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    }
}
else
{
    switch ($param1)
    {
        "updateJenkinsCore" {
            $Comm_Update = {& "$PSScriptRoot\core\upkeep\syncScripts.ps1" $PSScriptRoot $FilePath }
            Invoke-Command -ScriptBlock $Comm_Update
            Break
        }
        "updateTokens" {
            $Comm_UpdateTokens = {& "$PSScriptRoot\core\tools\TokenManager.ps1" $PSScriptRoot $FilePath }
            Invoke-Command -ScriptBlock $Comm_UpdateTokens
            Break
        }
        "updateGeneXus" {
            $Comm_UpdateGXInstallations = {& "$PSScriptRoot\core\utils\GXblConfigurator.ps1" $PSScriptRoot $FilePath }
            Invoke-Command -ScriptBlock $Comm_UpdateGXInstallations
            Break
        }
        "updatePipelines" {
            $Comm_UpdatePipelines = {& "$PSScriptRoot\core\upkeep\syncScripts.ps1" $PSScriptRoot $FilePath }
            Invoke-Command -ScriptBlock $Comm_UpdatePipelines
            # READ JENKINS_HOME
            $Comm_JENKINS_HOME = {& $Reader "Jenkins" "path" }
            $JENKINS_HOME = Invoke-Command -ScriptBlock $Comm_JENKINS_HOME
            Write-Output((Get-Date -Format G) + " INFO read JENKINS_HOME=$JENKINS_HOME") | Tee-Object -FilePath $JLOG -Append -Verbose
            # SYNC NEW SCRIPTS
            $Comm_UpdateLocalSettings = {& "$PSScriptRoot\core\utils\SyncLocalSettings.ps1" $PSScriptRoot $FilePath $JENKINS_HOME }
            Invoke-Command -ScriptBlock $Comm_UpdateLocalSettings
            Break
        }
        "clean" {
            $Comm_CleanDeploy = {& "$PSScriptRoot\core\upkeep\cleanDeploy.ps1" $PSScriptRoot $FilePath (1 -eq 0)}
            Invoke-Command -ScriptBlock $Comm_CleanDeploy
            Break
        }
        "uninstall" {
            $Comm_Uninstall = {& "$PSScriptRoot\core\upkeep\cleanDeploy.ps1" $PSScriptRoot $FilePath (1 -eq 1)}
            Invoke-Command -ScriptBlock $Comm_Uninstall
            Break
        }

        Default {
            Write-Output("updateJenkinsCore     | Update Jenkins core from git")
            Write-Output("updateTokens          | Update Jenkins credentials")
            Write-Output("updateGeneXus         | Update Jenkins Global configurations")
            Write-Output("updatePipelines       | Update available pipelines and local Jenkins files")
            Write-Output("clean                 | Delete all parameters in Jenkins setup")
            Write-Output("uninstall             | Delete Jenkins installation and clean Jenkins setup")
            throw "parameter not recognized"
        }
    }
}