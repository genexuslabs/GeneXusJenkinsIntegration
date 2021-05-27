param (
    [string] $ext = $(throw "missing extention")
)
$ConfigPath = (get-item $PSScriptRoot).parent.FullName + "\Jconfig.json"
if(Test-Path -path $ConfigPath)
{
    $JSON = Get-Content -Path $ConfigPath | ConvertFrom-Json
    return $JSON.$ext
}
else {
    Write-Output((Get-Date -Format G) + " ERROR missing Jconfig.json in $PSScriptRoot") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'missing Jconfig.json in $PSScriptRoot';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "missing Jconfig.json in $PSScriptRoot"
}