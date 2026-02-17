# Detection - tzautoupdate
$Log = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Detect-tzautoupdate.log"
function Log($msg) { $t = Get-Date -f "yyyy-MM-dd HH:mm:ss"; Add-Content $Log "[$t] $msg"; Write-Host $msg }

$svc = Get-Service tzautoupdate -ErrorAction SilentlyContinue
if ($null -eq $svc) { Log "Service not found"; exit 0 }

Log "Check: Status=$($svc.Status), StartType=$($svc.StartType)"

if ($svc.StartType -eq "Disabled" -and $svc.Status -eq "Stopped") {
    Log "Result: COMPLIANT - Service is disabled and stopped"
    exit 0
} else {
    Log "Result: NON-COMPLIANT - Service is not disabled/stopped. Remediation required."
    exit 1
}
