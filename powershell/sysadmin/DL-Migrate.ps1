### Migrates Distribution Group from On-Prem Group to Exchange Online Group

$DGName = Read-Host("Distribution Group to Migrate: ")
$NewDGName = Read-Host("New Distribution Group Name: ")

$DGMembers = Get-DistributionGroupMember $DGName | Select-Object PrimarySmtpAddress

New-DistributionGroup $NewDGName

foreach ($DGmember in $DGMembers) {
    Add-DistributionGroupMember "$NewDGName" -Member $DGmember.PrimarySmtpAddress
}