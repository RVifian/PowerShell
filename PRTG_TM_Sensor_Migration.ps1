# Script to Connect to PRTG and migrate Trend Micro
# v1.0 13.05.2024

#https://github.com/lordmilko/PrtgAPI

#1. Install-Package PrtgAPI
#2. Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#3. Import-Module PrtgAPI
#4. Connect-PrtgServer

# Check if the PrtgAPI module is installed, and if not, install it.
if (Get-Module -ListAvailable -Name PrtgAPI) {
} 
else {
    Install-Module -Name PrtgAPI
}

# Set the execution policy to unrestricted to allow the script to run.
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

# Import the PrtgAPI module.
Import-Module PrtgAPI

#List all devices 
Get-Device
Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

# Prompt the user to enter the username for which they want to retrieve session information.
$endpoint = Read-Host -Prompt "For which endpoint ID would you like to add sensors?"

#Device to install sensors
$device = Get-Device -Id $endpoint

#List all Trend Micro devices
$device | get-sensor | Where-Object {$_.Name -like "*Trend*"}

#List all TM Apex devices
$device | get-sensor | Where-Object {$_.Name -like "*Apex One*"}

Write-Host -NoNewLine 'Press any key to remove old sensors';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#Remove Old TM Apex Sensors
$device | get-sensor | Where-Object {$_.Name -like "*Apex One*"} | Remove-Object

#Confirm they are removed
$device | get-sensor | Where-Object {$_.Name -like "*Apex One*"}



#Get all current Trend Micro Services on the machine
$params = $device | Get-SensorTarget wmiservice "Trend Micro*" -Params

#Display found services
$params

Write-Host -NoNewLine 'Press any key to add new sensors';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

#Add Sensors to device
$device | Add-Sensor $params

#Confir new Trend Micro sensors
$device | get-sensor | Where-Object {$_.Name -like "*Trend*"}