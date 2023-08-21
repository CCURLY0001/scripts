Import-Module Microsoft.Online.SharePoint.PowerShell -UseWindowsPowerShell

Connect-SPOService -URL $url

Get-SPOSite | %{Set-SPOUser -Site $_.URL -LoginName ccolon@amserv.com -IsSiteCollectionAdmin $true}