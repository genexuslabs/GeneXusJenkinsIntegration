param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path"),
    [string] $GXSurl = $(throw "missing GXServer url"),
    [string] $GXSuser = $(throw "missing GXServer user"),
    [string] $GXSpass = $(throw "missing GXServer pass"),
    [string] $ProjectFile = $(throw "missing GXServer user")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
if(Test-Path -Path $ProjectFile)
{
    ## PARSE GXSERVER URL
    if($GXSurl.StartsWith("http"))
    {
        $GXSurl.Replace("https://","")
        $GXSurl.Replace("http://","")
    }
    $TURL = "$GXSurl/oauth/access_token"
    #$TURL
    ## GET TOKEN
    $Theader = @{
        "Content-Type"="application/x-www-form-urlencoded"
    }

    $Tbody = @{
        client_id='04b516e6fe7549faa22e1006e02505ac';
        grant_type='password';
        scope='FullControl';
        username=$GXSuser;
        password=$GXSpass;
        additional_parameters='%7B%22AuthenticationTypeName%22%3A%22*<tipo autenticacion>*%22%2C%22Repository%22%3A%22a9b30c7d-888a-45fa-9493-3f9aaadedae0%22%7D';
    }
    Write-Output((Get-Date -Format G) + " INFO call ../oauth/access_token") | Tee-Object -FilePath $JLOG -Append -Verbose
    $arrayOutPut = Invoke-RestMethod -Uri $TURL -Method 'Post' -Body $Tbody -Headers $Theader #| ConvertTo-HTML

    $filePath = "$ROOT\core\services\templates\GXStoken.txt"
    $finalXML = "$ROOT\core\services\templates\GXStoken.xml"
    if(Test-Path -Path $filePath)
    { Remove-Item -Path $filePath -Force}
    if(Test-Path -Path $finalXML)
    { Remove-Item -Path $finalXML -Force}
    $null = New-Item -Path $filePath
    foreach($line in $arrayOutPut)
    {
        Add-Content -Path $filePath -Value $line
    }
    #Get-Content $filePath | Set-Content $finalXML

    ## READ TOKEN
    $WWComm11 = {& "$ROOT\core\services\helpers\gxstokenReader.ps1"} 
    $TOKEN = Invoke-Command -ScriptBlock $WWComm11
    if(-not ([string]::IsNullOrEmpty($TOKEN)))
    {
        $SURL = "https://$GXSurl/rest/configureprovider" #"configureprovider"
        Write-Output((Get-Date -Format G) + " INFO call ../rest/configureprovider") | Tee-Object -FilePath $JLOG -Append -Verbose
        $Sheader = @{
            "Authorization" = "oauth $TOKEN"
            "Content-Type"="application/json"
        }
        $jsonrep = Get-Content -Path $ProjectFile | ConvertFrom-Json
        $jsonrep
        $response = Invoke-RestMethod -Uri $SURL -Method 'Post' -Headers $Sheader -Body $jsonrep
        $response

    }

}

#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#