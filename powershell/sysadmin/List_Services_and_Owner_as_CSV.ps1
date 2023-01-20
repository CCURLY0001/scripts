(Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*' }).Name | 
    ForEach-Object{
        Get-CimInstance -ComputerName $_ -ClassName Win32_Service | 
        Select-Object Name, DisplayName, StartMode, State, StartName, Description | 
        Export-CSV C:\Users\ccolon\Desktop\test\$_.Csv
    }