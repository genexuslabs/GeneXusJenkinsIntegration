param (
    [string] $ROOT = $(throw "miss script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
$MetaWriter = "$ROOT\keys\helpers\HSwriter.ps1"
try {
    #### No tengo chance de encontrar este hardcode por Registry pero como lo instala el InstallerMan deberia estar siempre aca
    $HARDPATH = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin"
    if(Test-Path -Path "$HARDPATH\MSBuild.exe")
    {
        Write-Output((Get-Date -Format G) + " INFO search MSBuild installation (by choco)") | Tee-Object -FilePath $JLOG -Append -Verbose
        $MSBuildName = "MSBuildVS2019"
        #$MSBuildName
        $MSBuildPath = $HARDPATH+"\"
        #$MSBuildPath
    }
    else 
    {
        Write-Output((Get-Date -Format G) + " INFO search MSBuild installation (in Registry)") | Tee-Object -FilePath $JLOG -Append -Verbose
        ## FIND MSBuild
        $MSBuild = Resolve-Path HKLM:\SOFTWARE\Microsoft\MSBuild\ToolsVersions\* | Get-ItemProperty -Name MSBuildToolsPath | select -Last 1
        $MSBuildName = "MSBuild"+$MSBuild.PSChildName
        #$MSBuildName
        $MSBuildPath = $MSBuild.MSBuildToolsPath
        #$MSBuildPath
    }
    if([string]::IsNullOrEmpty($MSBuildName) -or [string]::IsNullOrEmpty($MSBuildPath))
    {
        Write-Output((Get-Date -Format G) + " ERROR MSBuild installation not found, fail searching dependecie") | Tee-Object -FilePath $JLOG -Append -Verbose
        Write-Host -NoNewLine 'MSBuild installation not found, fail searching dependecie';
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
        throw "MSBuild Installation not found in Registry"
    }
    else {
        #### WRITE Jenkins path
        Write-Output((Get-Date -Format G) + " INFO write MSBuild.name=$MSBuildName") | Tee-Object -FilePath $JLOG -Append -Verbose
        $Comm_1 = {& $MetaWriter "MSBuild" "name" $MSBuildName }
        Invoke-Command -ScriptBlock $Comm_1
        #### WRITE Jenkins url
        Write-Output((Get-Date -Format G) + " INFO write MSBuild.path=$MSBuildPath") | Tee-Object -FilePath $JLOG -Append -Verbose
        $Comm_2 = {& $MetaWriter "MSBuild" "path" $MSBuildPath }
        Invoke-Command -ScriptBlock $Comm_2
    }
}
catch { $_}