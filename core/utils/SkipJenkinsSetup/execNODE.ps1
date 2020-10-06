param (
    [string] $ROOT = $(throw "miss script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
#### execute skip setup wizard
Write-Output((Get-Date -Format G) + " RUN nose index.js") | Tee-Object -FilePath $JLOG -Append -Verbose
cmd.exe /c node .\index.js
