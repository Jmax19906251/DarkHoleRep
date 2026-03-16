# =============================================================================
# Uninstall-NetworkDriveMapper.ps1
# Deployment  : Intune Win32 - User Context
# Description : Disconnects M: drive mapping
# Log         : C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Map-NetworkDrive.log
# =============================================================================

$DriveLetter = "M"
$LogFile     = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Map-NetworkDrive.log"

function Write-Log {
    param([string]$Message)
    $Entry = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
    Add-Content -Path $LogFile -Value $Entry
    Write-Output $Entry
}

Write-Log "=== Uninstall started ==="

if (Get-PSDrive -Name $DriveLetter -ErrorAction SilentlyContinue) {
    $Result = net use "${DriveLetter}:" /delete /yes 2>&1
    Write-Log "Drive ${DriveLetter}: removed - $Result"
} else {
    Write-Log "Drive ${DriveLetter}: was not mapped. Nothing to remove."
}

Write-Log "=== Uninstall complete ==="
exit 0
