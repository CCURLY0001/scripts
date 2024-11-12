<#
Powershell Module File for Windows Sysadmin

Author: Cristian Colon

Collection of functions / scripts I've had a desire to develop to better support Information Technology Operations 

#>

<# SECTION 1: LOCAL DEVICE INFORMATION #>
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

function Get-Services {
    Get-CimInstance -ClassName Win32_Service | 
    Select-Object Name, DisplayName, StartMode, State, StartName, Description
}


<# SECTION 2: DEVICE NETWORKING INFORMATION #>
function Get-PublicIP {
    (Invoke-WebRequest ifconfig.me/ip).Content
}

