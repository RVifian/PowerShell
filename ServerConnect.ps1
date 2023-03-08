# Script to Connect to PAW from local
# v1.0 08.03.2022

# Get credentials
$UserCredential = Get-Credential

# Get Server
$Server = Read-Host -Prompt "Which server do you want to connect to?"

# Creates a new PowerShell session with the Server
$Session = New-PSSession -ComputerName $Server -Authentication Kerberos -Credential $UserCredential

# Imports the commands from the remote PowerShell session into the current session.
Import-PSSession $Session -DisableNameChecking -Module ActiveDirectory

# Remind User to close Session while the session is active
function prompt {
    if ($global:Session) {
        Write-Host "Don't forget to run 'Remove-PSSession `$Session' before closing the session." -ForegroundColor Yellow
        if ($null -eq (Get-PSSession | Where-Object { $_.Id -eq $global:Session.Id })) {
            $global:Session = $null
        }
    }
    return "PS $($executionContext.SessionState.Path.CurrentLocation)> "
}

# Try to close Session automatically on Exit of PowerShell
$handler = {
    if ($global:Session) {
        Remove-PSSession $global:Session
    }
}
Register-EngineEvent PowerShell.Exiting -Action $handler