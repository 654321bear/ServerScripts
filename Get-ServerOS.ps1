$Computers = Import-CSV -Path "c:\temp\computers.txt" #-Header "Name"
ForEach ($Computer In $Computers)
{
  Try
  {
   Get-ADComputer -Identity $Computer.Name -Properties Name, operatingSystem |Select Name, operatingSystem
   echo Computer.name
  }
  Catch
  {
    $Computer.Name + " not in AD"
  }
}