####
#### .\Exchange-AccountCreation.ps1 -NewUser (Get-Content -Path NewUsers.txt)
##########################################################################
[CmdletBinding(SupportsShouldProcess=$false, ConfirmImpact='Medium')]
param (
[parameter(
Mandatory=$false,
ValueFromPipeline=$true)
]
[String[]]$NewUser=$Env:NewUser
)

#### Open the shell for exchange
Import-Module "E:\Exchange Server\V15\bin\RemoteExchange.ps1"
Connect-ExchangeServer -auto -ClientApplication:ManagementShell

#### Comand to create email account in O365
# Enable-RemoteMailbox {username}@COMPANY.com -RemoteRoutingAddress {username}@COMPANY.mail.onmicrosoft.com
foreach ($User in $NewUser){
    #Split fields into values
    $User1 = $User -split (",")
    $UN = $User1[0]
    $EM = $User1[1]
    #Enable-RemoteMailbox $User@meritenergy.com -RemoteRoutingAddress $User@meritenergyco.mail.onmicrosoft.com
    Write-Host $UN@COMPANY.com $EM@COMPANY.mail.onmicrosoft.com 
}