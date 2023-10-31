# Enable Antimalware Extension
Enable-AzureRmVMAntiMalwareExtension -ResourceGroupName "<YourResourceGroupName>" -VMName $env:COMPUTERNAME -Name "IaaSAntimalware" -Publisher "Microsoft.Azure.Security" -Type "IaaSAntimalware" -TypeHandlerVersion "1.7"

# Configure Antimalware Extension Settings
$antimalwareSettings = @{
    "AntimalwareEnabled" = $true
    "RealtimeProtectionEnabled" = $true
    "ScheduledScanSettings" = @{
        "isEnabled" = $true
        "day" = 7  # Saturday
        "time" = 120  # 2:00 AM
    }
}
Set-AzureRmVMAntiMalwareExtension -ResourceGroupName "<YourResourceGroupName>" -VMName $env:COMPUTERNAME -Name "IaaSAntimalware" -Publisher "Microsoft.Azure.Security" -Type "IaaSAntimalware" -TypeHandlerVersion "1.7" -Settings $antimalwareSettings
