param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
$MetaReader = "$ROOT\keys\helpers\HSreader.ps1"

$Command = {& $MetaReader "GitHub" "repo" }
$REPO = Invoke-Command -ScriptBlock $Command
Write-Output((Get-Date -Format G) + " INFO read GitHub.repo=$REPO") | Tee-Object -FilePath $JLOG -Append -Verbose
#$REPO
$Parent = (get-item $ROOT).parent.FullName
Set-Location -Path $Parent

Write-Output((Get-Date -Format G) + " RUN git pull") | Tee-Object -FilePath $JLOG -Append -Verbose
try {
    git pull $REPO --allow-unrelated-histories | Tee-Object -FilePath $JLOG -Append -Verbose
}
catch
{
    Write-Output((Get-Date -Format G) + " " + $_) | Tee-Object -FilePath $JLOG -Append -Verbose
}
#
Set-Location -Path $ROOT
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#