# Script to create readable Input File for TrencMicro SMEX
# v1.0 24.05.2023

# Prompt the user to enter the group names separated by commas
$groups = Read-Host "Enter the group names (separated by commas)"

# Split the input into an array of group names and trim any leading/trailing spaces
$groupList = $groups -split "," | ForEach-Object { $_.Trim() }

# Initialize the variable to store the result
$result = foreach ($group in $groupList) {
    # Retrieve the members of each group and get their AD user details
    $members = Get-ADGroupMember -Identity $group -Recursive | Get-ADUser

    # Iterate over each member and format the desired string
    foreach ($member in $members) {
        [string]::Format("{0}##{1}&&&swlegal\{1} {0}`r", $member.GivenName, $member.Surname)
    }
}

# Output the result to a file
$result | Out-File -FilePath C:\Temp\all_users.txt -Encoding utf8
