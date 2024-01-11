# Set the path to your folder
$folderPath = "C:\Path\To\Your\Folder"

# Set the date to 1/1/1970
$newDate = Get-Date -Year 1970 -Month 1 -Day 1 -Hour 0 -Minute 0

# Get all items (files and folders) within the specified folder and its subfolders (recursive)
$items = Get-ChildItem -Path $folderPath -Recurse

# Set the "Date modified" attribute to 1/1/1970 for each item
foreach ($item in $items) {
    $item.LastWriteTime = $newDate
}

# Optional: Display the updated information for each item
$items
