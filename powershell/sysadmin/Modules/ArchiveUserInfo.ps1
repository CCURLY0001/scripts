# TODO: Find way to limit scope of # Required
#Requires -Modules @{ ModuleName="Microsoft.Graph" ; ModuleVersion="2.2.0" }
#Requires -Modules @{ ModuleName="ActiveDirectory" ; ModuleVersion="1.0.1.0" }
#Requires -Modules @{ ModuleName="Microsoft.Online.SharePoint.PowerShell" ; ModuleVersion="1.0" }


# Gather User information
$userFirstName = Read-Host("User First Name")
$userLastName = Read-Host("User Last Name")
$userFLast = ($userFirstName.Substring(0,1) + $userLastName).ToLower()

$mailDomain = Read-Host("Enter Mail Domain (@contoso.com)")
$userEmail = $userFLast + $mailDomain

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


