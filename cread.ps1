$logPath = "C:\Logs\MyLog.txt"
$logMessage = "Log entry: $(Get-Date) - Something happened."

# Ensure the log directory exists
$directory = [System.IO.Path]::GetDirectoryName($logPath)
if (-not (Test-Path -Path $directory)) {
    New-Item -ItemType Directory -Path $directory | Out-Null
}

# Write log entry to the file
Add-Content -Path $logPath -Value $logMessage

# Now you can continue with the rest of your script...
# For example, adding credentials to Credential Manager
$storageAccount = "yourstorageaccount"
$fileShare = "yourfileshare"
$storageAccountKey = "yourstorageaccountkey"

$credential = New-Object PSCredential ("$storageAccount\$fileShare", (ConvertTo-SecureString $storageAccountKey -AsPlainText -Force))

# Add credential to Credential Manager
cmdkey /generic:YOURSTORAGEACCOUNT.file.core.windows.net /user:$($credential.UserName) /pass:$($credential.GetNetworkCredential().Password)
