<#
 Study taken from Windows Powershell Cookbook Third Edition
 Written By: Holmes
 Published: O'Reilly
#>

<#
Group Data as a Hash Table for repeated calling to provided hash

Group-Object can be called to selected property as a hash on a pivot hashtable.

Utilize the -AsString Paramater to prevent the need for explicit Int64 casts when calling the hash if it's of Int32 type.
#>

$curDir = Get-ChildItem | Group-Object -AsHash -AsString Length
$curDir

<#
Name Value
---- -----
123  {filename.txt}
#>