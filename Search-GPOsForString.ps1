# Script to search GPO for a string
# v1.0 28.02.2022
 
#Get the search-string
$string = Read-Host -Prompt "What string do you want to search for?" 
 
#Set the domain
$DomainName = $env:USERDNSDOMAIN 
 
#Find all GPOs
write-host "Finding all the GPOs in $DomainName" 
Import-Module grouppolicy 
$allGposInDomain = Get-GPO -All -Domain $DomainName 
 
#Look through all GPO's XML for the string 
Write-Host "Starting search...." 
foreach ($gpo in $allGposInDomain) { 
    $report = Get-GPOReport -Guid $gpo.Id -ReportType Xml 
    if ($report -match $string) { 
        write-host "********** Match found in: $($gpo.DisplayName) **********" 
    } 
}