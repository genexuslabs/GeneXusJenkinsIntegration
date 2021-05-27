param (
    [string] $ext,
    [string] $ext2
)
$ConfigPath = (get-item $PSScriptRoot).parent.FullName + "\HSmeta.json"
if(Test-Path -path $ConfigPath)
{
    $JSON = Get-Content -Path $ConfigPath | ConvertFrom-Json
    $JSON.$ext.$ext2
}
else {
    Write-Output((Get-Date -Format G) + " ERROR missing HSmeta.json in $PSScriptRoot") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'missing HSmeta.json in $PSScriptRoot';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "missing HSmeta.json in $PSScriptRoot"
}