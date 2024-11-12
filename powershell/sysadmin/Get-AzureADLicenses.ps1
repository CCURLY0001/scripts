# Get CSV Storage location
$csvfile = Read-Host ("CSV File Location: ")

<# Properties that need to be selected can be adjusted as needed. Get-MgUser -Name [name] | Get-Member should list all properties available #>
Get-MgUser -All -Property Id, DisplayName, UserPrincipalName, AssignedLicenses, AssignedPlans, LicenseAssignmentStates | Select-Object -Property Id, DisplayName, UserPrincipalName, AssignedLicenses, AssignedPlans, LicenseAssignmentStates |
Select-Object Id, DisplayName, UserPrincipalName, @{Label="AssignedLicenses";Expression={($_.AssignedLicenses.SkuID).trim()}}, AssignedPlans, LicenseAssignmentStates |
Export-CSV $csvfile

<#
Rewritten for Microsoft Graph on Nov 6, 2024.
Below is kept for archival purposes.

#Retrieve all users from Azure AD
$users = Get-AzureADUser -All $true

# Retrieve assigned licenses for each user
$licenses = ForEach-Object ($user in $users) {
    $userID = $user.ObjectID
    $license = Get-AzureADUserLicenseDetail -ObjectId $userID | 
        Select-Object -ExpandProperty AssignedLicense
}

#>