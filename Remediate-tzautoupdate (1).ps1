# Remediation - tzautoupdate
$Log = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Remediate-tzautoupdate.log"
function Log($msg) { $t = Get-Date -f "yyyy-MM-dd HH:mm:ss"; Add-Content $Log "[$t] $msg"; Write-Host $msg }

$svc = Get-Service tzautoupdate -ErrorAction SilentlyContinue
if ($null -eq $svc) { Log "Service not found"; exit 0 }

Log "Before: Status=$($svc.Status), StartType=$($svc.StartType)"

try {
    if ($svc.StartType -ne "Disabled") {
        Set-Service tzautoupdate -StartupType Disabled -ErrorAction Stop
        Log "Change: StartType set to Disabled"
    } else {
        Log "Change: StartType was already Disabled - no change needed"
    }

    if ($svc.Status -eq "Running") {
        Stop-Service tzautoupdate -Force -ErrorAction Stop
        Log "Change: Service was Running - stopped"
    } else {
        Log "Change: Service was already Stopped - no change needed"
    }

    $v = Get-Service tzautoupdate
    Log "After: Status=$($v.Status), StartType=$($v.StartType)"
    Log "Result: Remediation successful"
    exit 0
} catch {
    Log "Result: FAILED - $($_.Exception.Message)"
    exit 1
}
