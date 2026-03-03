
# Disable-ProtectedMode.ps1
# Sets bProtectedMode = 0 in Adobe Acrobat DC policy and logs the change.

$LogFile = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Disable-AcrobatProtectedMode.log"
$Path    = "HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown"

function Write-Log ([string]$Message) {
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $Message"
    Write-Host $line
    $line | Out-File -FilePath $LogFile -Append -Encoding utf8
}

Write-Log "--- Disable-AcrobatProtectedMode START ---"

# Apply the change
New-ItemProperty -Path $Path -Name "bProtectedMode" -Value 0 -PropertyType DWord -Force | Out-Null
Write-Log "bProtectedMode set to 0 (Protected Mode disabled)."

Write-Log "--- Disable-AcrobatProtectedMode END ---"
exit 0











# Uninstall-ProtectedMode.ps1
# Sets bProtectedMode = 1 in Adobe Acrobat DC policy and logs the change.

$LogFile = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Uninstall-AcrobatProtectedMode.log"
$Path    = "HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown"

function Write-Log ([string]$Message) {
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $Message"
    Write-Host $line
    $line | Out-File -FilePath $LogFile -Append -Encoding utf8
}

Write-Log "--- Uninstall-AcrobatProtectedMode START ---"

New-ItemProperty -Path $Path -Name "bProtectedMode" -Value 1 -PropertyType DWord -Force | Out-Null
Write-Log "bProtectedMode set to 1 (Protected Mode re-enabled)."

Write-Log "--- Uninstall-AcrobatProtectedMode END ---"
exit 0













# Detect-ProtectedMode.ps1

$Path = "HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown"

$value = (Get-ItemProperty -Path $Path -Name "bProtectedMode").bProtectedMode

if ($value -eq 0) {
    Write-Output "DETECTED: bProtectedMode = 0"
    exit 0
} else {
    exit 1
}