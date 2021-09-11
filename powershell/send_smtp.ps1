# Set paramaters for cmdlet into a hashtable and pass this to the cmdlet
# To Do: Set UseSSL Switch Paramater in params hashtable

$params = @{ 'SmtpServer' = 'smtp.gmail.com'
             'Port' = 587
             'Credential'= Get-Credential
             'From' = 'First Last <email.com>'
             'To' = 'First Last <email.com>'
             'Subject' = 'Test Subject'
             'Body' = 'Test Body'
           }

Send-MailMessage -UseSsl @params
