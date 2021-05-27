param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
$Writer = "$ROOT\conf\set\writer.ps1"
try {
    Write-Output((Get-Date -Format G) + " INFO searching JENKINS_HOME...") | Tee-Object -FilePath $JLOG -Append -Verbose
    $Jenkins = Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\services\Jenkins 
    $JENKINS_HOME = $Jenkins.ImagePath.Replace("`"","").Replace("\jenkins.exe","")
    #$JENKINS_HOME
    if(Test-Path -Path "$JENKINS_HOME\secrets")
    {
        #### WRITE Jenkins path
        Write-Output((Get-Date -Format G) + " INFO write Jenkins.path=$JENKINS_HOME") | Tee-Object -FilePath $JLOG -Append -Verbose
        $Comm_1 = {& $Writer "Jenkins" "path" $JENKINS_HOME }
        Invoke-Command -ScriptBlock $Comm_1
        #### WRITE Jenkins url
        Write-Output((Get-Date -Format G) + " INFO write Jenkins.url=http://localhost:8080") | Tee-Object -FilePath $JLOG -Append -Verbose
        $Comm_2 = {& $Writer "Jenkins" "url" "localhost:8080" }
        Invoke-Command -ScriptBlock $Comm_2
        #### WRITE Jenkins exists
        $Comm_2 = {& $Writer "Jenkins" "exists" true }
        Invoke-Command -ScriptBlock $Comm_2
    }
    else {
        Write-Output((Get-Date -Format G) + " ERROR Jenkins path not found in Registry, maybe isn't installed?") | Tee-Object -FilePath $JLOG -Append -Verbose
        Write-Host -NoNewLine 'Jenkins path not found in Registry, maybe isnt installed?';
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
        throw "Jenkins path not found in Registry, maybe isn't installed? "
    }
}
catch { $_}