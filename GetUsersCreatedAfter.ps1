#Set-ExecutionPolicy RemoteSigned
import-module ActiveDirectory
$When = ((Get-Date).AddDays(-30)).Date
Get-ADUser -Filter {whenCreated -ge $When}  -Properties whenCreated