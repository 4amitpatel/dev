$ErrorAction = "Stop"

# Define Log variables
$LogName = "Windows PowerShell"  # Change to the actual log name you want to use
$LogSource = "PowerShell"  # Use an existing or default event source

# Install NuGet package provider
Install-PackageProvider -Name NuGet -Force -ErrorAction $ErrorAction

# Install CredentialManager module
Install-Module CredentialManager -Force -ErrorAction $ErrorAction

# Import CredentialManager module
Import-Module -Name CredentialManager -ErrorAction $ErrorAction

# Create a new stored credential
New-StoredCredential -Target "webdav.mc.gmx.net" -Username "Username" -Password "Password" -Type Generic -Persist Enterprise -ErrorAction $ErrorAction

# Check if the event source exists, if not, create it
if (-not [System.Diagnostics.EventLog]::SourceExists($LogSource)) {
    # Register the event source with the event log
    New-EventLog -LogName $LogName -Source $LogSource -ErrorAction SilentlyContinue
}

# Write a message to the event log
$WriteMessage = "Credential Manager has been installed"
Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -EventId 01 -Message $WriteMessage -ErrorAction $ErrorAction
