# Initialize variables
[string]$brand = (Read-Host "HP or DELL").ToLower()
$url = ''

# Set URL to HP / DELL Site as necessary
Switch ($brand)
{
    "HP" { $url = 'https://support.hp.com/us-en/checkwarranty' }
    "DELL" { $url = 'https://www.dell.com/support/home/en-us?app=warranty' }
    default { "Unrecognized Brand. `n" }
}

# Quick null / empty space check on $url in case hp or dell was not accepted.
if ([string]::IsNullOrEmpty($url))
{
    Write-Host "No value stored for url variable. `nDid you have a typo in your brand? `n`nExiting Script..."
    break
}

Write-Host "Checking $url for warranty status"

Invoke-WebRequest $url
