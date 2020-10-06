param (
    [string] $head = $(throw "miss head parameter"),
    [string] $ext = $(throw "miss name parameter"),
    [string] $value = $(throw "miss path parameter")
)
$ConfigPath = (get-item $PSScriptRoot).parent.FullName + "\HSmeta.json"
if(Test-Path -path $ConfigPath)
{
    $ConfigFile = Get-Content -Path $ConfigPath | ConvertFrom-Json
    $ConfigFile.$head.$ext  = $value
    $ConfigFile | ConvertTo-Json | Out-File $ConfigPath
}
else {
    Write-Output((Get-Date -Format G) + " ERROR missing HSmeta.json in $PSScriptRoot") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'missing HSmeta.json in $PSScriptRoot';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "missing HSmeta.json in $PSScriptRoot"
}