param (
    [string] $param1,
    [string] $param2,
    [string] $param3,
    [string] $param4,
    [string] $param5,
    [string] $param6,
    [string] $param7,
    [string] $param8,
    [string] $param9
)
### constants
$FilePath = "$PSScriptRoot\jenkins.log"
if([string]::IsNullOrEmpty($param1))
{
    $aux = "$PSScriptRoot\core\IrunAs.ps1 $PSScriptRoot $FilePath"
    Start-Process "powershell.exe" -ArgumentList $aux -Verb RunAs
}
else
{

    switch ($param1)
    {
        "/h" {
            Write-Output("")
            Write-Output("")
            Write-Output("")
            Write-Output("")
            Write-Output("")
            Write-Output("")
            Write-Output("")
            Write-Output("")
            Break            
        }
        "installdependencie" {
            #param2 = dependencie name
            if([string]::IsNullOrEmpty($param2))
            {
                throw "missing dependencie name to install"
            }
            else
            {                
                $IOper = "$PSScriptRoot\core\tools\InstallerOperator.ps1"
                $Comm = {& $IOper $param2 $FilePath (0 -eq 1) }
                Invoke-Command -ScriptBlock $Comm
            }
            Break            
        }
        "updatedependencie" {
            #param2 = dependencie name
            if([string]::IsNullOrEmpty($param2))
            {
                throw "missing dependencie name to install"
            }
            else
            {                
                $IOper = "$PSScriptRoot\core\tools\InstallerOperator.ps1"
                $Comm = {& $IOper $param2 $FilePath (1 -eq 1) }
                Invoke-Command -ScriptBlock $Comm
            }
            Break    
        }
        "installjenkins" {       
            $IOper = "$PSScriptRoot\core\tools\InstallerOperator.ps1"
            $Comm = {& $IOper "jenkins" $FilePath (1 -eq 1) }
            Invoke-Command -ScriptBlock $Comm
            Break       
        }
        "updatecore" {
            $Command1 = {& "$PSScriptRoot\upkeeper\syncScripts.ps1" $PSScriptRoot $FilePath }
            Invoke-Command -ScriptBlock $Command1
            Break
        }
        "syncciscripts" {
            #param2 source
            if([string]::IsNullOrEmpty($param2))
            {
                throw "missing github Username and password "
            }
            else
            {
                $Command1 = {& "$PSScriptRoot\core\utils\SyncLocalSettings.ps1" $PSScriptRoot $FilePath $param2 }
                Invoke-Command -ScriptBlock $Command1
            }
            Break
        }
        "installmsbuildplugin" {echo "installmsbuildplugin1"}
        "installgenexusplugin" {echo "installgenexusplugin1"}
        "installcustomtoolplugins" {echo "installcustomtoolplugins1"}
        "installblueocean" {echo "installblueocean1"}
        "createoperatoruser" {echo "createoperatoruser1"}
        "gettokenbycredential" {echo "gettokenbycredential1"}
        "setprovider" {echo "setprovider1"}
        Default {
            throw "parameter not recognized"
        }
    }
}