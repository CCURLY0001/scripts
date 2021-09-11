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


# Establish row to start reading data from and how many total rows as casted integers
[int]$startRow = Read-Host "Input First Data Row: "
[int]$rowTotal = Read-Host "Input Total Rows: "


# Set paramaters for cmdlet into a hashtable and pass this to the cmdlet
# To Do: Set UseSSL Switch Paramater in params hashtable
$params = @{ 'SmtpServer' = 'smtp.gmail.com'
             'Port' = 587
             'Credential'= Get-Credential
             'From' = 'First Last <example@example.com>'
             'To' = 'First Last <example@example.com>'
             'Subject' = ''
             'Body' = ''
           }

# For startRow while not above rowTotal, run the loop and increment by 1
for ( $startRow ; $startRow -le $rowTotal ; $startRow++)
{
    # Check the cell at location $startRow,$dateCol for a Date time and determine if less than or equal to $checkDate
    if ( [DateTime]$ws.Cells($startRow,$dateCol).Text -le $checkDate )
    {
        # Set Customer Name as variable (saves on typing)
        # Set inside of if statement to only write to variable when needed
        $custName = $ws.Cells($startRow,1).Text

        # Set Subject and Body paramaters based on customer name.
        $params['Subject'] = $custName + " needs a SonicWALL License expiration"
        $params['Body'] = $custName + " needs a SonicWALL License expiration! `nLicense expires on " + $ws.Cells($startRow,$dateCol).Text

        Send-MailMessage -UseSsl @params
    }
}
