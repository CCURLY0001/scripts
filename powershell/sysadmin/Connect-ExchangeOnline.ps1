<# 
Connecting to Exchange Online
Written by: Cristian Colón
Date: 01/10/2023
#>

<#
First time powershell setup should be as follows:

Trust PS Gallery if not already trusted
Get-PSRepository
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Install Exchange Online if not already installed
Install-Module -Name ExchangeOnlineManagement
#>

# Import Exchange Online
Import-Module ExchangeOnlineManagement

# Connect-ExchangeOnline to connect with O365 [-UseRPSSession] will be deprecated soon
Connect-ExchangeOnline -UserPrincipalName (UPN) [-UseRPSSession]

# Exchange Online Powershell commands go here
Get-OrganizationConfig

# Disconnect Exchange Online from Powershell when done
Disconnect-ExchangeOnline