param (
    [string] $ext = $(throw "missing extention")
)
$ConfigPath = (get-item $PSScriptRoot).parent.FullName + "\Jconfig.json"
if(Test-Path -path $ConfigPath)
{
    $JSON = Get-Content -Path $ConfigPath | ConvertFrom-Json
    $GXInstallations = $JSON.$ext
    $Flag = (1 -eq 0)
    foreach($GX in $GXInstallations)
    {
        if(-not($Flag))
        {
            $Flag = (1 -eq 1)
            $GX.name
            $GX.path
        }
    }
}
else {
    Write-Output((Get-Date -Format G) + " ERROR missing Jconfig.json in $PSScriptRoot") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'missing Jconfig.json in $PSScriptRoot';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "missing Jconfig.json in $PSScriptRoot"
}