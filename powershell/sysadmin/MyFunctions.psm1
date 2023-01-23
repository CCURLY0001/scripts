<#
Powershell Custom Module File for Windows Sysadmin
Author: Cristian Colon
#>

# Define Invoke-DcDiag and accept 1 String paramater $DomainControllers
function Invoke-DcDiag {
    param (
        [Parameter (Mandatory)]
        [ValidateNotNullOrEmpty()]
# To-Do: Rewrite this to accept multiple Domain Controllers, or accept from pipe
        [string]$DomainControllers
    )

    # Store output of dcdiag /s:$ to variable for piping later
    $result = dcdiag /s:$DomainController

    # Pipe output of previous command through RegEx search and apply RegEx Groups to a custom Powershell Object;
    # Print said Object ForEach Matched String Pattern;
    # This stores the Object with Powershell Object attributes, so they can be called upon as needed.
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