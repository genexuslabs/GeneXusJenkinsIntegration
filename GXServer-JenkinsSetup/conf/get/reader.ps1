param (
    [string] $ext,
    [string] $ext2
)
$ConfigPath = (get-item $PSScriptRoot).parent.FullName + "\Jconfig.json"
if(Test-Path -path $ConfigPath)
{
    $JSON = Get-Content -Path $ConfigPath | ConvertFrom-Json
    $JSON.$ext.$ext2
}
else {
    Write-Output((Get-Date -Format G) + " ERROR missing Jconfig.json in $PSScriptRoot") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'missing Jconfig.json in $PSScriptRoot';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "missing Jconfig.json in $PSScriptRoot"
}