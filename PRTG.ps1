
# Script to Connect to PRTG and migrate Trend Micro
# v1.0 13.05.2024

#https://github.com/lordmilko/PrtgAPI

#1. Install-Package PrtgAPI
#2. Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#3. Import-Module PrtgAPI
#4. Connect-PrtgServer

#List all devices (Get-Device)

#Device to install sensors
$device = Get-Device -Id 3629

#List all Trend Micro devices
$device | get-sensor | Where-Object {$_.Name -like "*Trend*"}

#List all TM Apex devices
$device | get-sensor | Where-Object {$_.Name -like "*Apex One*"}

#Remove Old TM Apex Sensors
$device | get-sensor | Where-Object {$_.Name -like "*Apex One*"} | Remove-Object

#Confirm they are removed
$device | get-sensor | Where-Object {$_.Name -like "*Apex One*"}

#Get all current Trend Micro Services on the machine
$params = $device | Get-SensorTarget wmiservice "Trend Micro*" -Params

#Add Sensors to device
$device | Add-Sensor $params

#Confir new Trend Micro sensors
$device | get-sensor | Where-Object {$_.Name -like "*Trend*"}