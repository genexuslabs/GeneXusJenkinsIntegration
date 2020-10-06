param (
    [string] $value = $(throw "miss path parameter")
)
$ConfigPath = (get-item $PSScriptRoot).parent.FullName + "\Jusers.json"
if(Test-Path -path $ConfigPath)
{
    $ConfigFile = Get-Content -Path $ConfigPath | ConvertFrom-Json
    $ConfigFile.admin.token  = $value
    $ConfigFile | ConvertTo-Json | Out-File $ConfigPath
}
else {
    Write-Output((Get-Date -Format G) + " ERROR missing meta.json in $PSScriptRoot") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'missing meta.json in $PSScriptRoot';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "missing meta.json in $PSScriptRoot"
}