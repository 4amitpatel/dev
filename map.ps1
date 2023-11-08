$username = "demostroagetest"
$password = ConvertTo-SecureString -String "YvFtRGip8Tn9nCbGtZczLr5cKCWaoytE/cnLYlWuaE3IenDi4jwdOhqrbXmS3BlXTzt9jRQ4f08A+ASt01bBEg==" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $password

$driveLetter = "Z"
$storageAccountName = "demostroagetest"
$fileShareName = "demo"

$logFilePath = "C:\MountFileShareLog.txt"

# Create a timestamp for logging
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logEntry = "[$timestamp] "

# Check if the drive exists and remove it
if (Test-Path "${driveLetter}:\") {
    Remove-PSDrive -Name $driveLetter -Force
    $logEntry += "Drive " + $driveLetter + ":\ already exists and has been removed. "
}

# Map the network drive with credentials
try {
    New-PSDrive -Name $driveLetter -PSProvider FileSystem -Root "\\$($storageAccountName).file.core.windows.net\$($fileShareName)" -Credential $credential -Persist -ErrorAction Stop
    $logEntry += "Drive " + $driveLetter + ":\ mapped successfully."
} catch {
    $logEntry += "Error: $_"
}

# Write log entry to C drive
Add-Content -Path $logFilePath -Value $logEntry
