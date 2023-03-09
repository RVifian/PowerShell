# Script to hide all contacts from global address book 
# v1.0 09.03.2022

# Get all Contacts and Pipe them into hide them from global address book
Get-MailContact -ResultSize Unlimited -Filter {HiddenFromAddressListsEnabled -eq $false} | Set-MailContact -HiddenFromAddressListsEnabled $true