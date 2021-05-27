param (
    [string] $ROOT = $(throw "missing script root"),
    [string] $JLOG = $(throw "missing jenkis.log path")
)
Write-Output((Get-Date -Format G) + " IN $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#
$Reader = "$ROOT\conf\get\reader.ps1"
$TokenReader = "$ROOT\keys\helpers\HStokenReader.ps1"
$TokenWriter = "$ROOT\keys\helpers\HStokenWriter.ps1"

#### GXaccount STEP
### READ
$Command_GXaccountID = {& $Reader "GXaccount" "id" }
$DTCid = Invoke-Command -ScriptBlock $Command_GXaccountID
Write-Output((Get-Date -Format G) + " INFO read GXServer.id=$DTCid") | Tee-Object -FilePath $JLOG -Append -Verbose
$Command_GXaccountUSER = {& $Reader "GXaccount" "GXuser" }
$DTCuser = Invoke-Command -ScriptBlock $Command_GXaccountUSER
Write-Output((Get-Date -Format G) + " INFO read GXServer.user=$GXSuser") | Tee-Object -FilePath $JLOG -Append -Verbose
$Command_GXaccountPASS = {& $Reader "GXaccount" "GXpass" }
$DTCpass = Invoke-Command -ScriptBlock $Command_GXaccountPASS
Write-Output((Get-Date -Format G) + " INFO read GXServer.pass=********") | Tee-Object -FilePath $JLOG -Append -Verbose

if([string]::IsNullOrEmpty($DTCuser) -or [string]::IsNullOrEmpty($DTCpass) -or [string]::IsNullOrEmpty($DTCid))
{
    Write-Output((Get-Date -Format G) + " WARNING missing GXaccount credentials in Jconfig.json") | Tee-Object -FilePath $JLOG -Append -Verbose
}
else {
    ### GENERATE TOKEN
    try{
        $Command_06 = {& "$ROOT\core\tools\TokenOperator.ps1" $ROOT $JLOG $DTCid $DTCuser $DTCpass}
        $null = Invoke-Command -ScriptBlock $Command_06
        Write-Output((Get-Date -Format G) + " INFO write GXaccount token with id: $DTCid") | Tee-Object -FilePath $JLOG -Append -Verbose

    }
    catch{
        Write-Output((Get-Date -Format G) + " WARNING missing GXaccount credentials in Jconfig.json") | Tee-Object -FilePath $JLOG -Append -Verbose
        Write-Output((Get-Date -Format G) + " " + $_) | Tee-Object -FilePath $JLOG -Append -Verbose
    }
}

#### GXServer STEP
$Command_token = {& "$ROOT\conf\get\readerCollection.ps1" "GXServerCredentials" }
$GXSs = Invoke-Command -ScriptBlock $Command_token
foreach($GXS in $GXSs)
{
    if(! ([string]::IsNullOrEmpty($GXS.user) -or [string]::IsNullOrEmpty($GXS.pass) -or [string]::IsNullOrEmpty($GXS.id)))
    {
        ### GENERATE TOKEN
        $Command_gxs_token = {& "$ROOT\core\tools\TokenOperator.ps1" $ROOT $JLOG $GXS.id $GXS.user $GXS.pass}
        $null = Invoke-Command -ScriptBlock $Command_gxs_token
        Write-Output((Get-Date -Format G) + " INFO add GXServer token with id: " + $GXS.id) | Tee-Object -FilePath $JLOG -Append -Verbose
    }
}

#### SQLCredentials STEP
$Command_token = {& "$ROOT\conf\get\readerCollection.ps1" "SQLCredentials" }
$SQLs = Invoke-Command -ScriptBlock $Command_token
foreach($SQL in $SQLs)
{
    if(! ([string]::IsNullOrEmpty($SQL.user) -or [string]::IsNullOrEmpty($SQL.pass)))
    {
        ### GENERATE TOKEN
        $Command_sql_token = {& "$ROOT\core\tools\TokenOperator.ps1" $ROOT $JLOG $SQL.id $SQL.user $SQL.pass}
        $null = Invoke-Command -ScriptBlock $Command_sql_token
        Write-Output((Get-Date -Format G) + " INFO add SQL token with id: " + $SQL.id) | Tee-Object -FilePath $JLOG -Append -Verbose
    }
}

#
Write-Output((Get-Date -Format G) + " OUT $PSCommandPath") | Tee-Object -FilePath $JLOG -Append -Verbose
#