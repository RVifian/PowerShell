# Script to reinstall Windows Apps
# v1.0 09.03.2022

# Import Appx Module for Powershell 7
Import-Module Appx -usewindowspowershell

# List installed Apps
Get-AppxPackage | Select-Object Name, PackageFullName

# Reinstall specific App
# Example Photos
Get-AppxPackage -allusers Microsoft.Windows.Photos | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}

# Example Calculator
#Get-AppxPackage -allusers *Calculator* | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}

# Example Paint 3D
#Get-AppxPackage -allusers *MSPaint* | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}


#Reinstall All Apps
#Get-AppxPackage -allusers | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}