# Script to Connect to PRTG and Migrate Trend Micro
# v2.0 17.06.2024

# https://github.com/lordmilko/PrtgAPI

# Relevant services to monitor: 
# - Trend Micro Solution Platform
# - Trend Micro Cloud Endpoint Telemetry Service
# - Trend Micro Deep Security Agent
# - Trend Micro Deep Security Monitor
# - Trend Micro Endpoint Basecamp

# Irrelevant services:
# - Trend Micro Deep Security Notifier
# - Trend Micro Response Service

# Define variables for sensor names
$OldPattern = "*Apex One*"
$NewPattern = "*Trend*"


# Array of relevant services expected on the device.
$services = @(
    "Trend Micro Solution Platform",
    "Trend Micro Cloud Endpoint Telemetry Service",
    "Trend Micro Deep Security Agent",
    "Trend Micro Deep Security Monitor",
    "Trend Micro Endpoint Basecamp"
)

# Check if the PrtgAPI module is installed, and if not, install it.
if (Get-Module -ListAvailable -Name PrtgAPI) {
    # Module already installed, proceeding.
}
else {
    # Module not found, installing PrtgAPI module.
    Install-Module -Name PrtgAPI
}

# Check if the execution policy is already unrestricted, and if not, set it.
if ((Get-ExecutionPolicy -Scope Process) -ne 'Unrestricted') {
    # Set the execution policy to unrestricted to allow the script to run.
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted
}

# Check if the PrtgAPI module is imported, and if not, import it.
if (-not (Get-Module -Name PrtgAPI)) {
    # Import the PrtgAPI module.
    Import-Module PrtgAPI
}

# Check if already connected to the PRTG Server, and if not, connect.
if (-not (Get-PrtgClient)) {
    # Connect to the PRTG Server.
    Connect-PrtgServer
}

# List all devices and sort them.
Get-Device | Sort-Object

# Prompt the user to enter the device ID for which they want to add sensors.
$endpoint = Read-Host -Prompt "For which endpoint ID would you like to add sensors?"

# Retrieve the device information based on the provided ID.
$device = Get-Device -Id $endpoint

# List all sensors with names containing the $NewPattern on the specified device.
$device | Get-Sensor | Where-Object { $_.Name -like $NewPattern } | Select-Object -ExpandProperty Name

# List all sensors with names containing the $OldPattern on the specified device.
$apexOneSensors = $device | Get-Sensor | Where-Object { $_.Name -like $OldPattern } | Select-Object -ExpandProperty Name

# Only proceed if there are any sensors matching the $OldPattern.
if ($apexOneSensors) {
    # Display the names of the found sensors (optional).
    Write-Host "Found the following $OldPattern sensors:"
    $apexOneSensors | ForEach-Object { Write-Host $_ }

    # Wait for user input to remove old sensors.
    Write-Host -NoNewLine 'Press any key to remove old sensors'
    Write-Host ""
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

    # Remove old sensors with names containing the $OldPattern from the device.
    $device | Get-Sensor | Where-Object { $_.Name -like $OldPattern } | Remove-Object

    # Confirm that old sensors matching the $OldPattern are removed (no output is expected).
    $device | Get-Sensor | Where-Object { $_.Name -like $OldPattern }
}
else {
    Write-Host "No $OldPattern sensors found."
}

# Retrieve services from the device matching the $services pattern.
$trendSensors = $device | Get-SensorTarget wmiservice $services -Params

# Extract the list of services from the $trendSensors object.
$fullDeviceServices = $trendSensors.Services

# Display all device services without truncation.
$fullDeviceServices | ForEach-Object { Write-Output $_ }

# Filter device services to only include those in the $services array.
$params = $fullDeviceServices | Where-Object { $services -contains $_ }

# Check and output each service found in $services array.
$allServicesFound = $true
foreach ($service in $services) {
    $matchedService = $params | Where-Object { $_.DisplayName -eq $service }
    if ($matchedService) {
        Write-Output "Service found: $($matchedService.DisplayName)"
    }
    else {
        $allServicesFound = $false
    }
}

# Determine if all expected services are found on the device and add them as Sensors.
if ($allServicesFound) {
    Write-Host "All expected services are found on the device." -ForegroundColor Green
    Write-Host -NoNewLine 'Press any key to add new sensors'
    Write-Host ""
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    foreach ($trendSensor in $trendSensors) {
        $device | Add-Sensor $trendSensor
    }
}
else {
    Write-Host "Some expected services are missing on the device." -ForegroundColor Red
}

# Confirm new sensors matching the $NewPattern added to the device.
Write-Output "Newly installed sensors:"
$device | Get-Sensor | Where-Object { $_.Name -like $NewPattern } | Select-Object -ExpandProperty Name