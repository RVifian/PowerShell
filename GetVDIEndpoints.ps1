# Get VDI Endpoints
# v1.1 29.03.2023
# This PowerShell script connects to a VMware Horizon View Server and retrieves information about the sessions of a specified user.

# Check if the VMware PowerCLI module is installed, and if not, install it.
if (Get-Module -ListAvailable -Name VMware.PowerCLI) {
} 
else {
    Install-Module -Name VMware.PowerCLI
}

# Set the execution policy to unrestricted to allow the script to run.
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

# Import the VMware PowerCLI module.
Import-Module VMware.PowerCLI

# Set user domain
$DomainName = $env:USERDNSDOMAIN 

# Prompt the user for their credentials.
$UserCredential = Get-Credential

# Prompt the user to enter the username for which they want to retrieve session information.
$User = Read-Host -Prompt "For which user would you like to display the source host?"

# Set the invalid certificate action to ignore.
Set-PowerCLIConfiguration -InvalidCertificateAction:Ignore

# Connect to the VMware Horizon View Server using the specified server, domain, and user credentials.
Connect-HVServer -Server swl-vm004 -Domain swlegal -Credential $UserCredential

# Create a new query definition object for retrieving session information.
$query = New-Object "Vmware.Hv.QueryDefinition"

# Set the query entity type to SessionLocalSummaryView.
$query.queryEntityType = 'SessionLocalSummaryView'

# Create a new query service object.
$qSrv = New-Object "Vmware.Hv.QueryServiceService"

# Retrieve session information for the specified user from the Horizon View Server using the query service object.
# Select the relevant properties from the session information.
# Finally, filter the results to only show sessions for the specified user.
$qSRv.QueryService_Query($global:DefaultHVServers[0].ExtensionData,$query) | Select -ExpandProperty Results | Select -ExpandProperty NamesData | Select-Object -Property UserName,MachineOrRDSServerDNS,clientname  | Where-Object {$_.UserName -eq "$DomainName\$User"}