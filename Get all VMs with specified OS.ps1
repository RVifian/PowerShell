# Script to Get VM with specified OS
# v1.0 26.07.2023

$server = Read-Host -Prompt "What Server would you like to connect to?"

# Connect to a VMware vSphere server
Connect-VIServer $server

# Get search criteria
$SearchCriteria = Read-Host -Prompt "What are you searching for?"

# Get a list of virtual machines
Get-VM |

# Filter the virtual machines whose Guest Fullname (Operating System) contains "2022"
where{$_.ExtensionData.Config.GuestFullname -match "$SearchCriteria"} |

# Select the following properties for each virtual machine:
Select Name,

    # Custom calculated property: Configured OS (Guest Fullname from virtual machine's configuration)
    @{N="Configured OS";E={$_.ExtensionData.Config.GuestFullname}},

    # Custom calculated property: Running OS (Guest OS Full Name from the running virtual machine)
    @{N="Running OS";E={$_.Guest.OsFullName}},

    # Custom calculated property: Powered On (Check if the virtual machine is powered on)
    @{N="Powered On";E={ $_.PowerState -eq “PoweredOn”}},

    # Custom calculated property: disktype (Storage format of the virtual machine's hard disk)
    @{N="disktype";E={(Get-Harddisk $_).Storageformat}}
