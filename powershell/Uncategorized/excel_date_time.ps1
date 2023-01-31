# Create New COM Object and set it to excel spreadsheet (Tested on xlsx)
$excel = New-Object -Com Excel.Application
$wb = $excel.Workbooks.Open("C:\Users\Cristian\Documents\Test.xlsx")

# Worksheets are indicated by index starting at 1
$ws = $wb.Sheets.Item(1)

# Get Current Date and set Check Date to 30 days in the future
$curDate = Get-Date
$checkDate = [DateTime]$curDate.AddDays(30)

# Gather accurate Expiration Date Column
$dateCol = Read-Host "Input Date Column: "
$wsDateCol = $ws.Columns($dateCol)


# Establish row to start reading data from and how many total rows as integers
[int]$startRow = Read-Host "Input First Data Row: "
[int]$rowTotal = Read-Host "Input Total Rows: "

# For startRow while not above rowTotal, run the loop and increment by 1
for ( $startRow ; $startRow -le $rowTotal ; $startRow++)
{
    if ( [DateTime]$ws.Cells($startRow,$dateCol).Text -le $checkDate )
    {
        Write-Host $ws.Cells($startRow,1).Text needs a SonicWALL License Renewal!
    }
    # This is a True Fals test and will be taken out
    else
    {
        Write-Host "poopoopeepee"
    }
}
