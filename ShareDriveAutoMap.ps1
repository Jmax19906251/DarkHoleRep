
$UNCPath     = "\\SERVER\userdata\ENVNAME"   # <-- Replace SERVER and ENVNAME
$DriveLetter = "M"
$LogFile     = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Map-NetworkDrive.log"

# Ensure log directory exists
if (-not (Test-Path (Split-Path $LogFile))) {
    New-Item -ItemType Directory -Path (Split-Path $LogFile) -Force | Out-Null
}

function Write-Log {
    param([string]$Message)
    $Entry = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
    Add-Content -Path $LogFile -Value $Entry
    Write-Output $Entry
}

Write-Log "=== Map-NetworkDrive started ==="
Write-Log "Target: $UNCPath -> ${DriveLetter}:"

# Wait until the share is reachable (checks every 5s, up to 2 minutes)
Write-Log "Waiting for share to become reachable..."
$Timeout = 120
$Elapsed = 0

while ($Elapsed -lt $Timeout) {
    if (Test-Path $UNCPath) {
        Write-Log "Share reachable after ${Elapsed}s."
        break
    }
    Write-Log "Not reachable yet... (${Elapsed}s elapsed)"
    Start-Sleep -Seconds 5
    $Elapsed += 5
}

# If share never became reachable, log and exit
if (-not (Test-Path $UNCPath)) {
    Write-Log "ERROR: Share not reachable after ${Timeout}s. Exiting."
    exit 1
}

# Wait 10 seconds to let the connection stabilize
Write-Log "Waiting 10s for connection to stabilize..."
Start-Sleep -Seconds 10

# Remove existing mapping if present
if (Get-PSDrive -Name $DriveLetter -ErrorAction SilentlyContinue) {
    Write-Log "Existing ${DriveLetter}: mapping found. Removing..."
    $Remove = net use "${DriveLetter}:" /delete /yes 2>&1
    Write-Log "Remove result: $Remove"
}

# Map the drive
Write-Log "Mapping ${DriveLetter}: to $UNCPath..."
$Result = net use "${DriveLetter}:" $UNCPath /persistent:no 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Log "SUCCESS: ${DriveLetter}: mapped successfully."
    exit 0
} else {
    Write-Log "ERROR: Mapping failed - $Result"
    exit 1
}
