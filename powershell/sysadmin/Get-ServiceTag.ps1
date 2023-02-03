$list = Get-ADComputer -Filter * | Select-Object -Property DNSHostName
$cred = Get-Credential
$versions = @{
    19042 = '20H2'
    19044 = '21H2'
    19045 = '22H2'
}

$scriptBlock = {
    $compInfo = Get-ComputerInfo
    $compInfo |
    Select-Object -Property BiosManufacturer,
                            @{Label='Model';Expression={$compInfo.CsModel}},
                            BiosSerialNumber,
                            @{Label='Winows 10 Version';Expression={$versions[$compInfo.OsBuildNumber]}},
                            @{Label='Host Name';Expression={$compInfo.CsDNSHostName}},
                            @{Label='User Name';Expression={$compInfo.CsUserName}}
}

## To-Do: Append data to a csv for filtering.
## Future idea: Submit Service Tag to Vendor site to check warranty status.
## Optional: Store this status in the csv.
$list | 
ForEach-Object {

    try {
        Test-Connection -ComputerName $_.DNSHostName -Count 1 -ErrorAction Stop | Out-Null

        Invoke-Command -ComputerName $_.DNSHostName -Credential $cred -ScriptBlock $scriptBlock |
    }

    catch {
            Write-Warning -Message "Unable to connect to Computer: $_.DNSHostName"
    }
}