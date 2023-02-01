<#
Powershell Module File for Windows Sysadmin
Author: Cristian Colon
#>

function Invoke-DcDiag {

    <#
    .SYNOPSIS
        Returns Domain Health as operatable Powershell Objects. 
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
    
    [CmdletBinding()]
        param (
            
            [Parameter (Mandatory,
                        ValueFromPipeline)]
            [ValidateNotNullOrEmpty()]
            [string[]]$ComputerName
    
        )
    
        # Store output of dcdiag /s:$ to variable for pipeline later
        foreach ( $Computer in $ComputerName ) {
            try {
                Write-Verbose "Testing connection to: $Computer..."
                Test-Connection -ComputerName $Computer -Count 1 -ErrorAction Stop | Out-Null
                
                Write-Verbose -Message "Running DCDiag on $Computer. This could take a minute..."
                $result = dcdiag /s:$Computer
    
                # Pipe output of previous command through RegEx search and apply RegEx Groups to a custom Powershell Object;
                # Print said Object ForEach Matched String Pattern;
                # This stores the Object with Powershell Object attributes, so they can be called upon as needed.
                Write-Verbose -Message "Parsing $Computer DCDiag test data."
                $result | 
                Select-String -Pattern '\. (.*) \b(f\w+|p\w+)\b test (.*)' | 
                ForEach-Object {
                    $obj = @{
                        Entity = $_.Matches.Groups[1].Value
                        TestResult = $_.Matches.Groups[2].Value
                        TestName = $_.Matches.Groups[3].Value
                    }
                    [pscustomobject]$obj
                }
            }
    
            catch {
                Write-Warning -Message "Unable to connect to Computer: $Computer"
            }
        }
    }
function Get-PublicIP {
    (Invoke-WebRequest ifconfig.me/ip).Content
}
function Get-Services {
    Get-CimInstance -ClassName Win32_Service | 
    Select-Object Name, DisplayName, StartMode, State, StartName, Description
}