$ConfigPath = (get-item $PSScriptRoot).parent.FullName + "\templates\crumb.json"
if(Test-Path -path $ConfigPath)
{
    $JSON = Get-Content -Path $ConfigPath | ConvertFrom-Json
    return $JSON.crumb
}
else {
    Write-Output((Get-Date -Format G) + " ERROR missing crumb.json in $PSScriptRoot") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'missing crumb.json in $PSScriptRoot';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "missing crumb.json in $PSScriptRoot"
}