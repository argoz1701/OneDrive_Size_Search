# Function to get OneDrive statistics for specific users.
Function Get-OneDriveStatsByUsername {
    param (
        [string[]]$Usernames  # Accept an array of usernames
    )
    process {
        foreach ($Username in $Usernames) {
            $oneDrive = Get-PnPTenantSite -IncludeOneDriveSites -Filter "Url -like 'https://tennant-my.sharepoint.com/personal/$Username*'" -Detailed |
                Select-Object Title, Owner, @{Name="StorageUsageGB"; Expression={[Math]::Round($_.StorageUsage / 1000, 2)}}, LastContentModifiedDate, Status

            if ($oneDrive) {
                [PSCustomObject]@{
                    "Display Name" = $oneDrive.Title
                    "Owner" = $oneDrive.Owner
                    "Storage Usage (GB)" = $oneDrive.StorageUsageGB
                    "Last Modified File Date" = $oneDrive.LastContentModifiedDate
                    "Status" = $oneDrive.Status
                }
            }
            else {
                Write-Host "User '$Username' does not have a OneDrive account."
            }
        }
    }
}

# Add users to check OneDrive size or if they have a OneDrive
Get-OneDriveStatsByUsername -Usernames  "user1", "user2", "userN" | export-csv -Path C:\Users_OneDriveSize.csv -NoTypeInformation
