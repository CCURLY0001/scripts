$csvfile = Read-Host ("CSV File Location: ")

Get-MgUser -All -Property Id, DisplayName, UserPrincipalName, AssignedLicenses, AssignedPlans, LicenseAssignmentStates | Select-Object -Property Id, DisplayName, UserPrincipalName, AssignedLicenses, AssignedPlans, LicenseAssignmentStates |
Select-Object Id, DisplayName, UserPrincipalName, @{Label="AssignedLicenses";Expression={($_.AssignedLicenses.SkuID).trim()}}, AssignedPlans, LicenseAssignmentStates |
Export-CSV $csvfile

### Rewritten for Microsoft Graph on 06/11/2024

# Retrieve all users from Azure AD
#$users = Get-AzureADUser -All $true

#$ Retrieve assigned licenses for each user
#$licenses = ForEach-Object ($user in $users) {
#    $userID = $user.ObjectID
#    $license = Get-AzureADUserLicenseDetail -ObjectId $userID | 
#        Select-Object -ExpandProperty AssignedLicense
#}