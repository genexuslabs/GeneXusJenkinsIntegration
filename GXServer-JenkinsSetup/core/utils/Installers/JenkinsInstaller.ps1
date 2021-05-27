param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path"),
    [string] $JENKINS_NEW_HOME
)
try
{
    $Package = "jenkins"
    $isInstalled = choco list -lo | Where-object { $_.ToLower().StartsWith($Package.ToLower()) }
    if(-not($isInstalled)){
        if(-not([string]::isNullOrEmpty($JENKINS_NEW_HOME)))
        {
            if(-not(Test-Path -Path $JENKINS_NEW_HOME))
            {
                Write-Output((Get-Date -Format G) + " INFO creating new location: $JENKINS_NEW_HOME") | Tee-Object -FilePath $JLOG -Append -Verbose
                $null = New-Item $JENKINS_NEW_HOME -ItemType directory
            }
            Write-Output((Get-Date -Format G) + " INFO installing Jenkins in $JENKINS_NEW_HOME") | Tee-Object -FilePath $JLOG -Append -Verbose
            choco install $Package --ia JENKINSDIR=$JENKINS_NEW_HOME -y #--no-progress | Tee-Object -FilePath $JLOG -Append -Verbose
        }
        else
        {
            Write-Output((Get-Date -Format G) + " INFO installing package: $Package") | Tee-Object -FilePath $JLOG -Append -Verbose
            choco install $Package -y #--no-progress | Tee-Object -FilePath $JLOG -Append -Verbose
        }
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
catch
{
    Write-Output((Get-Date -Format G) + " ERROR chocolatey internal error") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'chocolatey internal error';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "chocolatey internal error"
}