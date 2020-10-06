param (
    [string] $ROOT = $(throw "miss script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
$MetaReader = "$ROOT\keys\helpers\HSreader.ps1"

$Command_2 = {& $MetaReader "GitHub" "repo" }
$REPO = Invoke-Command -ScriptBlock $Command_2
Write-Output((Get-Date -Format G) + " INFO read GitHub.repo=$REPO") | Tee-Object -FilePath $JLOG -Append -Verbose
#$REPO
Set-Location -Path $ROOT

Write-Output((Get-Date -Format G) + " RUN git pull") | Tee-Object -FilePath $JLOG -Append -Verbose
git pull $REPO | Tee-Object -FilePath $JLOG -Append -Verbose
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#