$path = "T:\"
$dt = (get-date).addDays(-1)
Get-ChildItem $path -Recurse > c:\temp\FileAudit.txt #| Where-Object {$_.lastWriteTime -ge $dt}