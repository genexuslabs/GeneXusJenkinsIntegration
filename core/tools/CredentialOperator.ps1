param (
    [string] $ROOT = $(throw "miss script root"),
    [string] $JLOG = $(throw "missing jenkis.log path"),
    [string] $MSBuilsPath = $(throw "missing MSBUILD_PATH"),
    [string] $GXINSTALL = $(throw "missing GeneXus installation"),
    [string] $USER = $(throw "missing username DeployToCloud"),
    [string] $PASS = $(throw "missing password  DeployToCloud")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#

$MSBuildFile = "$ROOT\resources\templates\credential.msbuild"
$GXInstallationTask = "$GXINSTALL\Genexus.Tasks.targets"
$args = $MSBuildFile + ' /t:SetCredential /p:GXInstall="' + $GXInstallationTask + '" /p:Username=' + $USER + ' /p:Password=' + $PASS

$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.FileName = $MSBUILD_PATH + "msbuild.exe"
$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.UseShellExecute = $false
$pinfo.Arguments = $args
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
$p.Start() | Out-Null
$myobj = [pscustomobject]@{
    commandTitle = $commandTitle
    stdout = $p.StandardOutput.ReadToEnd()
    stderr = $p.StandardError.ReadToEnd()
    ExitCode = $p.ExitCode
}
foreach($line in $myobj.stdout)
{
    Write-Output($line) | Tee-Object -FilePath $JLOG -Append -Verbose
}
$p.WaitForExit()
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#