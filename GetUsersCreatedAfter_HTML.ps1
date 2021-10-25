#Set-ExecutionPolicy RemoteSigned
import-module ActiveDirectory
$When = ((Get-Date).AddDays(-30)).Date
Get-ADUser -Filter {whenCreated -ge $When}  -Properties whenCreated


#Initialise Array
$Report = @()
$FinalReport = @()

#Set Date variable
$a = date
$export = "c:\temp\New_Users_" + $a.Month + "_" + $a.Day + "_" + $a.Year + ".csv"

# Get all AD Users created in last 30 days
Get-ADUser -Filter {whenCreated -ge $When}  -Properties whenCreated  | %{

# Output hostname and lastLogonTimestamp into CSV
$Report = "" | select-object Name,SamAccountName,whenCreated,DistinguishedName
$Report.Name = $_.Name
$Report.SamAccountName = $_.SamAccountName
$Report.whenCreated = $_.whenCreated
$Report.DistinguishedName = $_.DistinguishedName
$FinalReport += $Report
echo $Report
}
echo $export
$FinalReport | export-csv $export -notypeinformation



#--------------------------------------------------------REPORT SECTION------------------------------------------------------------
#Global Functions
#This function generates a nice HTML output that uses CSS for style formatting.
function Generate-Report {
	Write-Output "<html><head><title></title><style type=""text/css"">.Error {color:#FF0000;font-weight: bold;}.Title {background: #0077D4;color: #FFFFFF;text-align:center;font-weight: bold;border-collapse: collapse;}.SubTitle {background: #DBDDEC;color: #000000;text-align:center;font-weight: bold;border-collapse: collapse;}.Normal {} .Table{border: 1px solid black;border-collapse: collapse;width: 100%;}</style></head><body>"
                
                #Add Computer DESCRIPTION Table
                Write-Output "<table border="1" class="table"><tr class=""Title""><td colspan=""4"">Users Added To The Active Directory In The Last 30 Days</td></tr><tr class=SubTitle><td>Name</td><td>samAccountName </td><td>When Created</td><td>DistinguishedName</td></tr>"
                Foreach ($Report in $FinalReport){
					Write-Output "<td>$($Report.Name)</td><td>$($Report.SamAccountName)</td><td>$($Report.whenCreated)</td><td>$($Report.DistinguishedName)</td></tr> " 
				}
                Write-Output "</table>"                

        #End Report Table
		Write-Output "</table></body></html>" 
	}
echo "Done with Report"





#Create attachments
$Masteratt = new-object Net.Mail.Attachment($export)

#Generate email and add attachments
	IF ($Report -ne ""){
	$SmtpClient = New-Object system.net.mail.smtpClient
	$SmtpClient.host = "alerts.meritenergy.com"   #Change to a SMTP server in your environment
	$MailMessage = New-Object system.net.mail.mailmessage
	$MailMessage.from = "AD.Automation@meritenergy.com"   #Change to email address you want emails to be coming from
	$MailMessage.To.add("john.thompson@meritenergy.com")	#Change to email address you would like to receive emails.
	$MailMessage.IsBodyHtml = 1
	$MailMessage.Subject = "Report of New Users Added in the Last 30 Days"
	$MailMessage.Body = Generate-Report
    $MailMessage.Attachments.Add($Masteratt)
	$SmtpClient.Send($MailMessage)}

#Delete files after email is sent
$Masteratt.Dispose()
Start-Sleep -s 10 
Remove-Item $export