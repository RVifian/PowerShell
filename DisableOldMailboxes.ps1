# Script to disable the mailboxes of users that are 1. in specified OU and 2. one year or longer disabled in Active Directory
# v1.0 26.08.2024

# Import the Active Directory and Exchange modules
Import-Module ActiveDirectory

# Define the OU to search in
$searchBase = "OU=_tmp_DisabledAccounts,OU=SWLEGAL,OU=Users,OU=Production,OU=_SWLEGAL,DC=swlegal,DC=intra"

# Define the date to compare (1 year ago from today)
$compareDate = (Get-Date).AddYears(-1)

# Get all users in the specified OU and sub-OUs where the account is disabled and the last logon date is older than one year
$users = Get-ADUser -SearchBase $searchBase -Filter {
    Enabled -eq $false -and LastLogonDate -lt $compareDate
} -Property LastLogonDate, DistinguishedName, sAMAccountName, mail

# Create a collection to hold the results
$results = @()

# Check if there are any users found
if ($users.Count -eq 0) {
    Write-Host "No users found that meet the criteria."
}
else {    
    # Loop through each user and add their sAMAccountName and Mail to the results collection
    foreach ($user in $users) {
        # Check if the sAMAccountName is "rsr"
        if ($user.sAMAccountName -ne "rsr") {
            $results += [PSCustomObject]@{
                sAMAccountName = $user.sAMAccountName
                Mail           = $user.mail
            } 
            # Disable the mailbox for the user
            Disable-Mailbox -Identity $user.DistinguishedName -Confirm:$false
            Write-Host "Disabled mailbox for user:" $user.sAMAccountName
        }
        else {
            Write-Host "Skipping user rsr"
        }  
    }
    # Export the results to a CSV file (to verify found users before disabling)
    $results | Export-Csv -Path "C:\Temp\MailboxesToDisable.csv" -NoTypeInformation
    Write-Host "Export completed. Results saved to C:\Temp\MailboxesToDisable.csv"
}
