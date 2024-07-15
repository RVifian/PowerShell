# Create a list of all msg files with their included attachments
# v1.0 15.07.2024

# Prompt user for the path where the .msg files are located
$folderPath = Read-Host "Enter the path where your .msg files are located"

# Prompt user for the output file path
$outputFile = Read-Host "Enter the path where you want to save the output CSV file"

# Initialize Outlook Application
$Outlook = New-Object -ComObject Outlook.Application

# Get all .msg files in the folder
$msgFiles = Get-ChildItem -Path $folderPath -Filter *.msg

# Prepare a list to store the results
$resultList = @()

foreach ($msgFile in $msgFiles) {
    try {
        # Load the .msg file
        $mailItem = $Outlook.Session.OpenSharedItem($msgFile.FullName)

        # Get the attachments
        $attachments = $mailItem.Attachments

        # Initialize a list to hold attachment names
        $attachmentNames = @()

        if ($attachments.Count -gt 0) {
            for ($i = 1; $i -le $attachments.Count; $i++) {
                $attachment = $attachments.Item($i)
                $attachmentNames += $attachment.FileName
            }
        } else {
            $attachmentNames += "No Attachments"
        }

        # Combine attachment names into a single string separated by a delimiter (e.g., semicolon)
        $attachmentsString = [string]::Join('; ', $attachmentNames)

        # Add to result list
        $resultList += [PSCustomObject]@{
            FileName       = $msgFile.Name
            AttachmentNames = $attachmentsString
        }

        # Release the COM object
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($mailItem) | Out-Null
    }
    catch {
        Write-Error "Failed to process file: $($msgFile.FullName). Error: $($_.Exception.Message)"
    }
}

# Release the COM object
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($Outlook) | Out-Null

# Export the results to a CSV file
$resultList | Export-Csv -Path $outputFile -NoTypeInformation

Write-Output "Attachment list saved to $outputFile"