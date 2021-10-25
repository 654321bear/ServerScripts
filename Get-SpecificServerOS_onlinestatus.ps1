$computers = Get-ADComputer -properties OperatingSystem,Name -Filter * `
    | Where-Object {$_.operatingsystem -match "Windows Server 2003"}

ForEach ($Computer In $Computers)
{
$name = $computer.Name
  if (Test-Connection -ComputerName $name -Count 1 -ErrorAction SilentlyContinue){
    Write-Host "$name,up"
  }
  else{
    Write-Host "$name,down"
  }
}

