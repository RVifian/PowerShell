# Monitor Bundesgerichtentscheide
# v1.0 12.11.2024
# This PowerShell script monitors the daily published data and informs the user if $TargetID got published by mail

# Define variables
$TargetID = "Foobar"
$Today = (Get-Date).ToString("yyyyMMdd")
$URL = "https://www.bger.ch/ext/eurospider/live/de/php/aza/http/index_aza.php?date=$Today&lang=de&mode=news"

# Function to check website for target ID
function Check-WebsiteForID {
    param ($TargetID, $URL)
    
    # Make the web request
    try {
        $Response = Invoke-WebRequest -Uri $URL -UseBasicParsing
    } catch {
        Write-Host "Error accessing the website: $_"
        return $false
    }

    # Check if the target ID is in the response content
    if ($Response.Content -match [regex]::Escape($TargetID)) {
        return $true
    } else {
        return $false
    }    
}

# Function to send email notification
function Send-EmailNotification {
    param ($TargetID)

    $SmtpServer = "Foobar.swlegal.intra"
    $SmtpFrom = "Foobar@swlegal.ch"
    $SmtpTo = "Foobar@swlegal.ch", "Foobar@swlegal.ch"
    $SmtpPort = 25
    $SmtpSubject = "Bundesgericht Checker"
    $SmtpBody = "Der Entscheid $TargetID ist heute aufgelistet."

    
    # Hardcode the credentials (plain text password)
    $Username = "Foobar"
    $Password = "Foobar"  # Maybe replace later with secure solution

    # Create SecureString and PSCredential objects
    $SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)

    try {
        # Attempt to send the email
        Send-MailMessage -From $SmtpFrom -To $SmtpTo -Subject $SmtpSubject -Body $SmtpBody -SmtpServer $SmtpServer -Port $SmtpPort -Credential $Credential
        Write-Host "Notification email sent successfully."
    } catch {
        # Output detailed error message for troubleshooting
        Write-Host "Error sending email: $($_.Exception.Message)"
        if ($_.Exception.InnerException) {
            Write-Host "Inner Exception: $($_.Exception.InnerException.Message)"
        }
    }
}

# Run the check and send notification if ID is found
if ((Get-Date).DayOfWeek -notin 'Saturday', 'Sunday') {  # Only run on weekdays
    if (Check-WebsiteForID -TargetID $TargetID -URL $URL) {
        Send-EmailNotification -TargetID $TargetID
    } else {
        Write-Host "Target ID not found for today."
    }
} else {
    Write-Host "Today is a weekend; no check will be performed."
}
