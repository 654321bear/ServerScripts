Write-Output "#######################                Registry Run Values                   ##########################"
Write-Output "####################### HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run  ##########################"
Write-Output "#######################################################################################################"
Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run 
Write-Output ""
Write-Output "#######################################################################################################"

Write-Output "#######################              Registry RunOnce Values                 ##########################"
Write-Output "####################### HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run  ##########################"
Write-Output "#######################################################################################################"
Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce
Write-Output ""
Write-Output "#######################################################################################################"

Write-Output "#######################                Get all Local Users                   ##########################"
Write-Output "#######################             PS command Get-LocalUser                 ##########################"
Write-Output "#######################################################################################################"
Get-LocalUser * | Format-Table
Write-Output ""
Write-Output "#######################################################################################################"


Write-Output "#######################                Get all Startup Items                 ##########################"
Write-Output "#######################  Items found in Shell:common startup & Shell:startup ##########################"
Write-Output "#######################################################################################################"
dir "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
dir "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
Write-Output ""
Write-Output "#######################################################################################################"

Write-Output "#######################                Get Content of Host File              ##########################"
Write-Output "#######################           C:\Windows\system32\drivers\etc\hosts      ##########################"
Write-Output "#######################################################################################################"
Get-Content C:\Windows\system32\drivers\etc\hosts
Write-Output ""
Write-Output "#######################################################################################################"

Write-Output "#######################                Get Running Processes                 ##########################"
Write-Output "#######################                                                      ##########################"
Write-Output "#######################################################################################################"
Get-Process -IncludeUserName | Format-Table Id, Name,Username, mainWindowtitle -AutoSize
Write-Output ""
Write-Output "#######################################################################################################"

Write-Output "#######################            Get Exchange Forwarding Rules             ##########################"
Write-Output "#######################                                                      ##########################"
Write-Output "#######################################################################################################"
$mailboxUser = Read-Host "Which Email account are we checking for forwarders?: "
Function Connect-EXOnline {
    $credentials = Get-Credential
    Write-Output "Getting the Exchange Online cmdlets"
    $Session = New-PSSession -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
        -ConfigurationName Microsoft.Exchange -Credential $credentials `
        -Authentication Basic -AllowRedirection
    Import-PSSession $Session -AllowClobber
}

Connect-EXOnline
$domains = Get-AcceptedDomain
$forwardingRules = $null
Write-Output "Checking rules for $mailboxuser" 
$rules = get-inboxrule -Mailbox $mailboxuser.primarysmtpaddress
     
$forwardingRules = $rules | Where-Object {$_.forwardto -or $_.forwardasattachmentto}
 
foreach ($rule in $forwardingRules) {
    $recipients = @()
    $recipients = $rule.ForwardTo | Where-Object {$_ -match "SMTP"}
    $recipients += $rule.ForwardAsAttachmentTo | Where-Object {$_ -match "SMTP"}
     
    $externalRecipients = @()
 
    foreach ($recipient in $recipients) {
        $email = ($recipient -split "SMTP:")[1].Trim("]")
        $domain = ($email -split "@")[1]
 
        if ($domains.DomainName -notcontains $domain) {
            $externalRecipients += $email
        }    
    }
 
    if ($externalRecipients) {
        $extRecString = $externalRecipients -join ", "
        Write-Output "$($rule.Name) forwards to $extRecString"
 
        $ruleHash = $null
        $ruleHash = [ordered]@{
            PrimarySmtpAddress = $mailbox.PrimarySmtpAddress
            DisplayName        = $mailbox.DisplayName
            RuleId             = $rule.Identity
            RuleName           = $rule.Name
            RuleDescription    = $rule.Description
            ExternalRecipients = $extRecString
        }
    }
}
Write-Output ""
Write-Output "#######################################################################################################"
