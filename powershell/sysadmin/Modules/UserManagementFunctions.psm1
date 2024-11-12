<#
Powershell Module File for Windows User (Domain & MgGraph) Administration

Author: Cristian Colon

Collection of functions / scripts I've had a desire to develop to better support Information Technology Operations 

#>

<# SECTION 1: NEW USER MANAGEMENT #>
function Add-UserToGroup {

    <#
.SYNOPSIS
    Returns Domain Health as interactable Powershell Objects. 
    This is equivalent to running dcdiag /s: on each provided DC.

.DESCRIPTION
    Invoke-DcDiag is a function that returns the list of tests 
    that would normally be provided via dcdiag in easy to parse,
    readable format, for quick troubleshooting and at-a-glance
    domain health.

.PARAMETER ComputerName
    The remote domain controllers to check the tests from.

.EXAMPLE
     Invoke-DCDiag -ComputerName 'Server1', 'Server2'

.INPUTS
    String

.OUTPUTS
    PSCustomObject

.NOTES
    Author:  Cristian Colón
    Website: http://cristiancolon.com
#>

    param (
        [string]$userId,
        [string[]]$groupId
    )

    $failedGroups = @()

    foreach ($group in $groupId) {

        try {
            New-MgGroupMember -GroupId $group -DirectoryObjectId $userId -ErrorAction Stop
            Write-Host "Successfully added user to group with ID: $group" -ForegroundColor Green
        }

        catch {
            Write-Host "Failed to add user to group with ID: $group. Error: $_" -ForegroundColor Red
            $failedGroups += $group
        }
    }

    Write-Host "Failed Groups Listed Below:"
    Write-Host ""
    
    # Fix the return of $failedGroups to be used in other functions.
    return $failedGroups
}

<# SECTION 2: USER MAINTENANCE & VERIFICATION #>

<# SECTION 2a: LOCAL USER/DIRECTORY MAINTENANCE #>

<# SECTION 2b: CLOUD USER/DIRECTORY MAINTENANCE #>
function Get-O365Licenses{
Get-MgUser -All -Property Id, DisplayName, UserPrincipalName, AssignedPlans |
Select-Object -Property Id, DisplayName, UserPrincipalName, AssignedPlans
}

<# SECTION 3: USER TERMINATION #>
function Get-GraphUser{

    [CmdletBinding()]
    param (
        [Parameter (Mandatory,
                    ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string[]]$userEmail
    )

    # Check for AzureAD / O365 User / Access
    Import-Module Microsoft.Graph

    # Connect to Graph API
    # Includes Scopes required for Get-MgUserMemberOf
    Connect-MgGraph -Scopes "Directory.Read.All","Directory.ReadWrite.All","GroupMember.Read.All","User.Read","User.Read.All","User.ReadBasic.All","User.ReadWrite.All"

    # Get Graph User
    $user = Get-MgUser -Filter "mail eq '$userEmail'" 

    # Display List of Groups member is a part of
    Get-MgUserMemberOf -UserID $user.id | ForEach-Object{Write-Host ($_.AdditionalProperties['displayName'])}
}

function Get-OnPremUser{
    
    [CmdletBinding()]
    param (
        [Parameter (Mandatory,
                    ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string[]]$userFLast
    )
    # Check for On-Prem User / Access
    Import-Module ActiveDirectory

    # TODO: Gather Necessary On-Prem Data
}

function Get-SharepointUser{

    [CmdletBinding()]
    param (
        [Parameter (Mandatory,
                    ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string[]]$userEmail
    )

    # Check for Sharepoint User / Access
    Import-Module Microsoft.Online.SharePoint.PowerShell -UseWindowsPowerShell
    $sharepointAdminUrl = Read-Host("Enter Sharepoint Admin URL (in form of 'https://contosocom-admin.sharepoint.com')")
    Connect-SPOService $sharepointAdminUrl
    
    # Get Sharepoint access - Group by Site, sort by group
    $arr = @(); Get-SPOSite |
        ForEach-Object { $user = Get-SPOUser -Site $_.URL -LoginName "$userEmail"
            if($user.Groups.Count -gt 0)
                {$arr += new-object psobject -property @{ site=$_.url ; groups=$user.Groups }
            }
        }
}

function Get-ExchangeOnlineUser{

    [CmdletBinding()]
    param (
        [Parameter (Mandatory,
                    ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string[]]$userEmail
    )

    # Check for Exchange Online User / Access
    Import-Module ExchangeOnlineManagement
    Connect-ExchangeOnline
}