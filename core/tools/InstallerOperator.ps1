param (
    [string] $Package = $(throw "miss requiered package to install"),
    [string] $JLOG = $(throw "missing jenkis.log path"),
    [Bool] $isUpdateable = $(throw "miss updateable package")
)
try
{
    $isInstalled = choco list -lo | Where-object { $_.ToLower().StartsWith($Package.ToLower()) }
    if(-not($isInstalled)){
        Write-Output((Get-Date -Format G) + " INFO installing package: $Package") | Tee-Object -FilePath $JLOG -Append -Verbose
        Write-Output("Installing Package: $Package")
        choco install $Package -y #--no-progress | Tee-Object -FilePath $JLOG -Append -Verbose
    }
    else{
        Write-Output((Get-Date -Format G) + " INFO already installed package: $Package") | Tee-Object -FilePath $JLOG -Append -Verbose
        if($isUpdateable)
        {
            Write-Output((Get-Date -Format G) + " INFO searching for available upgrades..") | Tee-Object -FilePath $JLOG -Append -Verbose
            choco upgrade $Package -y | Tee-Object -FilePath $JLOG -Append -Verbose
        }
    }
}
catch {
    $ChocoInstaller = "$ROOT\core\utils\Installers\ChocoInstaller.ps1"
    $Comm_1 = {& $ChocoInstaller $JLOG }
    Invoke-Command -ScriptBlock $Comm_1

    $ME = {& "$PSCommandPath" $Package $JLOG $isUpdateable}
    Invoke-Command -ScriptBlock $ME
}