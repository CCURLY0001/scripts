Get-CimInstance -ClassName Win32_Service | 
Select-Object Name, DisplayName, StartMode, State, StartName, Description | 
Export-CSV C:\Users\ccolon\Desktop\test.Csv