# Connect to your Azure account
Connect-AzAccount

# Select the subscription and resource group
$subscription = Get-AzSubscription | Out-GridView -Title 'Select Azure Subscription' -PassThru
Set-AzContext -Subscription $subscription

$resourceGroup = Get-AzResourceGroup | Out-GridView -Title 'Select Resource Group' -PassThru

# Get the list of VMs in the resource group
$vms = Get-AzVM -ResourceGroupName $resourceGroup.ResourceGroupName

# Select the VM to install the extensions
$vm = $vms | Out-GridView -Title 'Select VM' -PassThru

# Get the custom configuration script URL
$customScriptUrl = Read-Host "Enter the custom configuration script URL"

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
        "Publisher" = "Microsoft.Azure.Security"
        "Type" = "IaaSAntimalware"
        "TypeHandlerVersion" = $version
        "Settings" = @{}
        "ProtectedSettings" = @{
            "commandToExecute" = "powershell.exe -executionpolicy bypass -File $customScriptUrl"
        }
    }
    
    # Install the extension on the VM
    Set-AzVMExtension -Name $extension -VM $vm -Publisher "Microsoft.Compute" -ExtensionType "CustomScriptExtension" -TypeHandlerVersion "1.10" -TypeHandlerVersion "DSC" -ProtectedSettings $extensionParams.ProtectedSettings -Settings $extensionParams.Settings -Location $extensionParams.Location -ForceRerun -Verbose
}
