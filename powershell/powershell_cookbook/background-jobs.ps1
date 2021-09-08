<#

 Study taken from Windows Powershell Cookbook Third Edition
 Written By: Holmes
 Published: O'Reilly
 
 #>

<#
Inovke Long-Running or Background Commands
#>

Start-Job { while($true) {Get-Random; Start-Sleep 5 } } -Name Sleeper

<#
Other Background Command related tasks:

Get-Job
Wait-Job
Receive-Job
Stop-Job
Remove-Job

-AsJob can be used as a paramater in many cmdlets to run as background tasks as well.
#>
