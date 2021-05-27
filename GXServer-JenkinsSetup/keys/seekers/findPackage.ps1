param (
    [string] $PackageName = $(throw "missing package name")
)
$Comm = {& $PackageName -v}
try {
    $value = Invoke-Command -ScriptBlock $Comm
}
catch {
    $value = "false"
}
return $value