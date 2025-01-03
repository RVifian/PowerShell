# PowerShell Scripts

This repository contains a collection of PowerShell scripts designed to assist with various tasks. Below is an overview of each script.

## Scripts Overview

### 1. `BundesgerichtentscheideChecker.ps1`
Monitors daily published decisions on the Swiss Federal Supreme Court's website and sends an email notification if a specified target ID is found. The script only runs on weekdays and requires SMTP configuration for notifications.

### 2. `DisableOldMailboxes.ps1`
Disables the mailboxes of users in a specified Active Directory Organizational Unit (OU) who have been disabled for over a year. It skips specific accounts (e.g., "rsr") and exports the affected user details to a CSV file, ensuring that you can audit the accounts before proceeding.

### 3. `ExchangeConnect.ps1`
Connects to a specified Exchange server by prompting for user credentials and server address. This script establishes a remote PowerShell session, imports Exchange-related commands for local use, and ensures that the session is closed automatically when exiting PowerShell.

### 4. `ExchangeMaintenanceMode.ps1`
Manages the maintenance mode for Exchange Mailbox Servers within a Database Availability Group (DAG). It supports enabling and disabling maintenance mode, moving active databases between servers, and optionally performing server reboots during maintenance.

### 5. `Get-VMWithSpecifiedOS.ps1`
Connects to a VMware vSphere server and retrieves a list of virtual machines with a specified operating system. The script filters virtual machines based on the guest OS and displays details such as the configured OS, running OS, and power state for each machine.

### 6. `GetBootTime.ps1`
Retrieves the boot time of a specified server by using the `SystemInfo` command and filtering for the boot time entry. This script provides a quick way to check when a system was last restarted.

### 7. `GetVDIEndpoints.ps1`
Connects to a VMware Horizon View Server and retrieves session information for a specified user. It provides details such as the source host, client name, and machine or RDS server DNS, allowing for better monitoring and troubleshooting of virtual desktop infrastructure (VDI) sessions.

### 8. `HideContactsFromGAL.ps1`
Hides all mail contacts from the global address book by updating the `HiddenFromAddressListsEnabled` attribute for contacts that are currently visible. This is helpful for managing the visibility of contacts in large environments with many email addresses.

### 9. `LeastUsedPrinters.ps1`
Identifies the least used printers over the last 6 months by counting the number of print jobs per printer. The script then displays the printers with the lowest job counts, which can be useful for decommissioning underutilized printers and optimizing resources.

### 10. `MsgAttachmentList.ps1`
Creates a list of all `.msg` files in a specified folder and identifies any attachments included in those files. The script outputs this data into a CSV file for easy review, making it useful for tracking attachments in email message files.

### 11. `PRTG_TM_Sensor_Migration.ps1`
Connects to a PRTG (Paessler Router Traffic Grapher) server and migrates Trend Micro services from an old pattern to a new one. This script is designed to manage sensors related to Trend Micro services, removing old sensors associated with the Apex One service and replacing them with new sensors for the relevant Trend Micro services.

### 12. `ReinstallWindowsApps.ps1`
Reinstalls specific or all Windows apps for a user or all users on a system. It allows for the reinstallation of default apps such as Photos, Calculator, and Paint 3D, or all apps at once using PowerShell commands from the Appx module. This script is useful for troubleshooting or refreshing Windows app installations.

### 13. `RemoveDateModified.ps1`
This script recursively traverses a specified folder and sets the "Date modified" attribute of all files and folders within it to January 1, 1970. It can be used for tasks such as resetting modification timestamps or preparing files for specific testing scenarios where file modification dates need to be uniform or reset to a particular date. Optionally, the updated file details can be displayed after modification.

### 14. `Search-GPOsForString.ps1`
This script allows you to search through all Group Policy Objects (GPOs) in an Active Directory domain for a specific string. It prompts the user to input the string they want to search for, then retrieves all GPOs in the domain and checks their XML reports for the specified string. If a match is found, it outputs the name of the GPO where the string is present. This can be useful for auditing or finding specific configurations within GPOs.

### 15. `ServerConnect.ps1`
This script allows you to connect to a server from a local PowerShell session using Kerberos authentication. The user is prompted to enter their credentials, and the script establishes a remote PowerShell session to the specified server. It also imports commands from the remote session, particularly for managing Active Directory, and reminds the user to close the session when done. Additionally, the script attempts to automatically remove the PowerShell session when exiting PowerShell, ensuring clean session termination.

### 16. `TM_SMEX_ImportFile.ps1`
This script allows you to create a readable input file for Trend Micro SMEX by retrieving Active Directory group members and formatting their names in a specific way. It prompts the user to enter group names, splits the input into individual groups, retrieves each group's members, and formats the output as "GivenName##Surname&&&swlegal\Surname GivenName". The result is saved to a text file located at `C:\Temp\all_users.txt`, which can be used for further processing or integration with Trend Micro SMEX.

### 17. `TotalArchiveSize.ps1`
This script retrieves all archive mailboxes and their mailbox statistics, then calculates the sum of their sizes. It presents the result in gigabytes (GB) with a column header labeled "Total Archive Size (GB)." The script provides a quick overview of the total archive mailbox storage usage in an Exchange environment, which can help in managing and optimizing mailbox storage.
