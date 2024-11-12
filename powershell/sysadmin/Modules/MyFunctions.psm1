<#
Powershell Module File for Windows Sysadmin
Author: Cristian Colon
Collection of fucntions / scripts I've had a desire to develop
to better support Information Technology Operations 
#>

function Get-WindowsVersion {
    
    # Store Get-ComputerInfo into Variable
    $compInfo = Get-ComputerInfo
    
    ### To-Do: Dynamically populate $versions Hashtable 
    ### w/ accurate values pulled from https://learn.microsoft.com/en-us/windows/release-health/release-information
    # Hard-Coded Hashtable providing Build number to Common Name Windows Version
    $versions = @{
        19042 = '20H2'
        19044 = '21H2'
        19045 = '22H2'
    }

    $buildVersion = $versions[[int]$compInfo.OsBuildNumber]
    $buildVersion
}

function Get-PublicIP {
    (Invoke-WebRequest ifconfig.me/ip).Content
}
function Get-Services {
    Get-CimInstance -ClassName Win32_Service | 
    Select-Object Name, DisplayName, StartMode, State, StartName, Description
}

function Add-UserToGroup {
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