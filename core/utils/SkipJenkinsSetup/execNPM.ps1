param (
    [string] $ROOT = $(throw "miss script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
#### installing dependencies
Write-Output((Get-Date -Format G) + " RUN npm install") | Tee-Object -FilePath $JLOG -Append -Verbose
cmd.exe /c npm install 

#### LOG
Write-Output((Get-Date -Format G) + " INFO found installed npm $isNpm") | Tee-Object -FilePath $JLOG -Append -Verbose
Write-Output((Get-Date -Format G) + " INFO found installed node $isNode") | Tee-Object -FilePath $JLOG -Append -Verbose
Write-Output("===============================================================") | Tee-Object -FilePath $JLOG -Append -Verbose
Write-Output((Get-Date -Format G) + " INFO Skipping setup wizard") | Tee-Object -FilePath $JLOG -Append -Verbose
Write-Output("===============================================================") | Tee-Object -FilePath $JLOG -Append -Verbose
