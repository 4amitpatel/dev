# Define the list of extensions to install with their latest versions
$extensions = @{
    "AzureMonitorWindowsAgent" = (Get-AzVMExtensionImage -Location $vm.Location -PublisherName "MicrosoftMonitoringAgent" -Type "AzureMonitorWindowsAgent" | Sort-Object PublishedDate -Descending | Select-Object -First 1).Version
    "AzurePolicyforWindows" = (Get-AzVMExtensionImage -Location $vm.Location -PublisherName "Microsoft.Policy" -Type "AzurePolicyforWindows" | Sort-Object PublishedDate -Descending | Select-Object -First 1).Version
    "IaaSAntimalware" = (Get-AzVMExtensionImage -Location $vm.Location -PublisherName "Microsoft.Azure.Security" -Type "IaaSAntimalware" | Sort-Object PublishedDate -Descending | Select-Object -First 1).Version
}

# Install the extensions on the VM
foreach ($extension in $extensions.Keys) {
    $version = $extensions[$extension]

    $extensionParams = @{
        "VMName" = $vm.Name
        "ResourceGroupName" = $vm.ResourceGroupName
        "Location" = $vm.Location
        "ExtensionName" = $extension
        "Publisher" = "Microsoft.Compute"
        "Type" = "CustomScriptExtension"
        "TypeHandlerVersion" = $version
        "Settings" = @{
            # You will enter the custom script URL in the Azure portal during deployment
        }
    }

    # Install the extension on the VM
    Set-AzVMExtension -ResourceGroupName $extensionParams.ResourceGroupName -VMName $extensionParams.VMName -Name $extensionParams.ExtensionName -Publisher $extensionParams.Publisher -ExtensionType $extensionParams.Type -TypeHandlerVersion $extensionParams.TypeHandlerVersion -Settings $extensionParams.Settings -Location $extensionParams.Location -ForceRerun -Verbose
}
