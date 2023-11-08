# Mount Azure File Share with storage account access keys
function Get-TimeStamp {
return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}
$storageAccountName = "localhost\demostroagetest"
$fileShareName = "demostroagetest.file.core.windows.net"
$storageAccountKeys = "vFtRGip8Tn9nCbGtZczLr5cKCWaoytE/cnLYlWuaE3IenDi4jwdOhqrbXmS3BlXTzt9jRQ4f08A+ASt01bBEg=="

$connectTestResult = Test-NetConnection -ComputerName $("$storageAccountName.file.core.windows.net") -Port 445

if ($connectTestResult.TcpTestSucceeded) {
$password = ConvertTo-SecureString -String $storageAccountKeys -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "AZURE\$($storageAccountName)", $password
New-PSDrive -Name Z -PSProvider FileSystem -Root "\\$($storageAccountName).file.core.windows.net\$($fileShareName)" -Credential $credential -Persist
}
else {
Write-Output "$(Get-TimeStamp) Unable to reach the Azure storage account via port 445. Please check your network connection." | Out-File C:\FileShareMount.txt -Append
}
