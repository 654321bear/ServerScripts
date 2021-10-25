#Put this script on system that you want to get updates on C drive size.
$capacity = Get-WmiObject -Class Win32_logicaldisk -Filter "DriveType = '3'" | Select-Object -Property DeviceID, DriveType, VolumeName, @{L='FreeSpaceGB';E={"{0:N2}" -f ($_.FreeSpace /1GB)}}, @{L="Capacity";E={"{0:N2}" -f ($_.Size/1GB)}} | Out-String
echo $capacity
$test = echo $capacity
echo $test
#Generate email and add attachments

	$SmtpClient = New-Object system.net.mail.smtpClient
	$SmtpClient.host = "alerts.COMPANY.com"   #Change to a SMTP server in your environment
	$MailMessage = New-Object system.net.mail.mailmessage
	$MailMessage.from = "CerberusFTP@COMPANY.com"   #Change to email address you want emails to be coming from
	$MailMessage.To.add("USER@COMPANY.com")	#Change to email address you would like to receive emails.
	$MailMessage.Subject = "Cerberus Free Space"
	$MailMessage.Body = "Cerberus Free Space" + $capacity.ToString()
	$SmtpClient.Send($MailMessage)
echo $MailMessage.Body
echo "Done with Email"


# This section removes the reports after script completion
# If additional reports are added to this script, the Attachments field of this section must be updated
$SmtpClient.dispose()
$MailMessage.Dispose()