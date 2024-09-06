# Get least used Printers
# v1.0 04.09.2024

# Define the time range (last 6 months)
$endDate = Get-Date
$startDate = $endDate.AddMonths(-6)

# Get a list of all printers
$printers = Get-Printer | Select-Object -ExpandProperty Name

# Get all print job events and filter them manually
$printEvents = Get-WinEvent -LogName "Microsoft-Windows-PrintService/Operational"

# Filter the events by the time range and Event ID 307 (Document Printed)
$filteredEvents = $printEvents | Where-Object {
    $_.TimeCreated -ge $startDate -and $_.TimeCreated -le $endDate -and $_.Id -eq 307
}

# Initialize a hashtable to store printer job counts
$printerJobCounts = @{}

# Loop through each filtered event and count jobs per printer
foreach ($event in $filteredEvents) {
    $printerName = ($event.Properties[4].Value) -replace '"',''
    
    if ($printerJobCounts.ContainsKey($printerName)) {
        $printerJobCounts[$printerName]++
    } else {
        $printerJobCounts[$printerName] = 1
    }
}

# Add all printers to the hashtable, setting count to 0 for those with no jobs
foreach ($printer in $printers) {
    if (-not $printerJobCounts.ContainsKey($printer)) {
        $printerJobCounts[$printer] = 0
    }
}

# Sort the printers by the number of print jobs (ascending)
$sortedPrinters = $printerJobCounts.GetEnumerator() | Sort-Object Value

# Display the results
$sortedPrinters | ForEach-Object { 
    Write-Host "Printer: $($_.Key) - Job Count: $($_.Value)"
}
