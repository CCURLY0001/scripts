# Retrieve all users from Azure AD
$users = Get-AzureADUser -All $true

$ Retrieve assigned licenses for each user
$licenses = ForEach-Object ($user in $users) {
    $userID = $user.ObjectID
    $license = Get-AzureADUserLicenseDetail -ObjectId $userID | 
        Select-Object -ExpandProperty AssignedLicense
}