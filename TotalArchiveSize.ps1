# Script to hide all contacts from global address book 
# v1.0 13.03.2022

# This code retrieves all archive mailboxes and their mailbox statistics, calculates the sum of their sizes, and presents the result in GB in a table with the column header "Total Archive Size (GB)".

Get-Mailbox -Archive -ResultSize Unlimited | Get-MailboxStatistics | Select-Object DisplayName,@{Name='TotalItemSize';Expression={[int64]($_.TotalItemSize.Value.ToBytes())}} | Measure-Object -Property TotalItemSize -Sum | Select-Object @{Name='Total Archive Size (GB)';Expression={[math]::Round(($_.Sum / 1GB),2)}}
