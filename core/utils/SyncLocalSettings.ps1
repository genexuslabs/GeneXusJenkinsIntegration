param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path"),
    [string] $JENKINS_HOME = $(throw "missing JENKINS_HOME")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
### CONSTANTS
$Source = "$ROOT\resources\CIscripts"
### XCOPY
Write-Output((Get-Date -Format G) + " INFO sync pipeline scripting ") | Tee-Object -FilePath $JLOG -Append -Verbose
Copy-Item -Path $Source -Destination $JENKINS_HOME -Recurse -Force
#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#