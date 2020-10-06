param (
    [string] $head = $(throw "miss head parameter"),
    [string] $ext = $(throw "miss name parameter"),
    [string] $value = $(throw "miss path parameter")
)
$ConfigPath = (get-item $PSScriptRoot).parent.FullName + "\Jconfig.json"
if(Test-Path -path $ConfigPath)
{
    if(($value -eq "false") -or ($value -eq "true"))
    {
        $value = [boolean]$value
    }
    $ConfigFile = Get-Content -Path $ConfigPath | ConvertFrom-Json
    $ConfigFile.$head.$ext  = $value
    $ConfigFile | ConvertTo-Json | Out-File $ConfigPath
}
else {
    Write-Output((Get-Date -Format G) + " ERROR missing meta.json in $PSScriptRoot") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'missing meta.json in $PSScriptRoot';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "missing meta.json in $PSScriptRoot"
}