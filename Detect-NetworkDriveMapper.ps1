# =============================================================================
# Detect-NetworkDriveMapper.ps1
# Deployment  : Intune Win32 - Detection Script
# Description : Checks if M: drive is currently mapped.
# =============================================================================

if (Get-PSDrive -Name "M" -ErrorAction SilentlyContinue) {
    Write-Output "Detected: M: is mapped."
    exit 0
} else {
    exit 1
}
