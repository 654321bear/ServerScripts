<#
.Synopsis
   PowerShell script to list all Scheduled Tasks and the User ID
.DESCRIPTION
   This script scan the content of the c:\Windows\System32\tasks and search the UserID XML value. 
   The output of the script is a comma-separated log file containing the Computername, Task name, UserID.
#>

#Import-Module ActiveDirectory
#$VerbosePreference = "continue"
#$list = (Get-ADComputer -LDAPFilter "(&(objectcategory=computer)(OperatingSystem=*server*))").Name
$list = "<COMPUTERNAME>"
Write-Verbose  -Message "Trying to query $($list.count) servers found in AD"
$logfilepath = "C:\temp\TaskLog.csv"
$ErrorActionPreference = "SilentlyContinue"

foreach ($computername in $list)
{
    $path = "\\" + $computername + "\c$\Windows\System32\Tasks"
    $tasks = Get-ChildItem -Path $path -File

    if ($tasks)
    {
        Write-Verbose -Message "I found $($tasks.count) tasks for $computername"
    }

    foreach ($item in $tasks)
    {
        $AbsolutePath = $path + "\" + $item.Name
        $task = [xml] (Get-Content $AbsolutePath)
        [STRING]$check = $task.Task.Principals.Principal.UserId

        if ($task.Task.Principals.Principal.UserId)
        {
          Write-Verbose -Message "Writing the log file with values for $computername"           
          Add-content -path $logfilepath -Value "$computername,$item,$check"
          
        }

    }
}