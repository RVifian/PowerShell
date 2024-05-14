# Script to get boot time of a machine
# v1.0 14.05.2024

$Server = Read-Host -Prompt 'Input the server name'
SystemInfo /S $Server | find /i "Boot Time"