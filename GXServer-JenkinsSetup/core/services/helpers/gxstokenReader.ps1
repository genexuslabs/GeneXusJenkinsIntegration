$ConfigPath = (get-item $PSScriptRoot).parent.FullName + "\templates\GXStoken.txt"
if(Test-Path -path $ConfigPath)
{
    $arrayOutPut = Get-Content -Path $ConfigPath
                $auxSplit1 = $arrayOutPut -split "access_token="
                #$auxSplit1[0]
                $auxSplit2 = $auxSplit1[1] -split "; token_type="
                $TOKEN = $auxSplit2[0]
                $TOKEN
}
else {
    Write-Host -NoNewLine 'missing crumb.json in $PSScriptRoot';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "missing crumb.json in $PSScriptRoot"
}
