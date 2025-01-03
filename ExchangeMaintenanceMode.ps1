# Exchange Server Maintenance Mode
# v1.0 12.11.2024
# PowerShell Script for Managing Mailbox Server Maintenance Mode
# This script automates enabling and disabling maintenance mode on Mailbox Servers
# that are part of a Database Availability Group (DAG), with optional reboot functionality.

param (
    [string]$ServerName,        # The name of the server to manage
    [switch]$EnableMaintenance, # Flag to enable maintenance mode
    [switch]$DisableMaintenance, # Flag to disable maintenance mode
    [switch]$RebootServer       # Flag to reboot the server after enabling maintenance mode
)

# Enable Maintenance Mode
if ($EnableMaintenance) {
    Write-Host "Enabling Maintenance Mode for server: $ServerName" -ForegroundColor Cyan

    # Suspend the server in the cluster
    Suspend-ClusterNode -Name $ServerName

    # Disable database copy activation and move any active databases from the server
    Set-MailboxServer -Identity $ServerName -DatabaseCopyActivationDisabledAndMoveNow $True

    # Set the server-wide component state to 'Inactive' for maintenance
    Set-ServerComponentState -Identity $ServerName -Component ServerWideOffline -State Inactive -Requester Maintenance

    # Verification step: Check the component states to ensure they are 'Inactive'
    Write-Host "Verifying Maintenance Mode status..." -ForegroundColor Yellow
    Get-ServerComponentState -Identity $ServerName | Format-Table Component,State -AutoSize
    Write-Host "Maintenance Mode Enabled. Server is ready for reboot or maintenance tasks." -ForegroundColor Green
}

# Reboot the Server
if ($RebootServer) {
    # Ensure that maintenance mode is enabled before rebooting
    if (-not $EnableMaintenance) {
        Write-Host "Reboot option requires Maintenance Mode to be enabled first. Exiting." -ForegroundColor Red
        exit
    }

    Write-Host "Rebooting server: $ServerName..." -ForegroundColor Cyan

    # Initiate a forced reboot of the server
    Restart-Computer -ComputerName $ServerName -Force
    Write-Host "Reboot initiated. Please allow the server to restart." -ForegroundColor Green
}

# Disable Maintenance Mode
if ($DisableMaintenance) {
    Write-Host "Disabling Maintenance Mode for server: $ServerName" -ForegroundColor Cyan

    # Restore the server-wide component state to 'Active'
    Set-ServerComponentState -Identity $ServerName -Component ServerWideOffline -State Active -Requester Maintenance

    # Resume the server in the cluster
    Resume-ClusterNode -Name $ServerName

    # Enable database copy activation and allow active databases to move back to the server
    Set-MailboxServer -Identity $ServerName -DatabaseCopyActivationDisabledAndMoveNow $False

    # Verification step: Check the component states to ensure they are 'Active'
    Write-Host "Verifying Maintenance Mode status..." -ForegroundColor Yellow
    Get-ServerComponentState -Identity $ServerName | Format-Table Component,State -AutoSize
    Write-Host "Maintenance Mode Disabled. Server is back to normal operation." -ForegroundColor Green
}

# Display Usage Instructions
if (-not $EnableMaintenance -and -not $DisableMaintenance) {
    Write-Host "Usage: Provide one of the following parameters:" -ForegroundColor Cyan
    Write-Host "  -EnableMaintenance : To enable maintenance mode on the server."
    Write-Host "  -DisableMaintenance : To disable maintenance mode on the server."
    Write-Host "  -RebootServer : Reboot the server (requires maintenance mode enabled first)."
}