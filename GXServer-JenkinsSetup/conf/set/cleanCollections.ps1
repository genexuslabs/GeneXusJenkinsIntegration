param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $ext = $(throw "missing extention")
)
$ConfigPath = "$ROOT\conf\Jconfig.json"
if(Test-Path -path $ConfigPath)
{
    $JSON = Get-Content -Path $ConfigPath | ConvertFrom-Json
    $Collection = $JSON.$ext
    #$JSON.GeneXus
    foreach($item in $Collection){
        try{ $item.id = "" } catch {}
        try{ $item.name = "" } catch {}
        try{ $item.user = "" } catch {}
        try{ $item.path = "" } catch {}
        try{ $item.pass = "" } catch {}
    }    
    $JSON | ConvertTo-Json -Depth 4 | Out-File $ConfigPath
}
else {
    Write-Output((Get-Date -Format G) + " ERROR missing Jconfig.json in $PSScriptRoot") | Tee-Object -FilePath $JLOG -Append -Verbose
    Write-Host -NoNewLine 'missing Jconfig.json in $PSScriptRoot';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    throw "missing Jconfig.json in $PSScriptRoot"
}