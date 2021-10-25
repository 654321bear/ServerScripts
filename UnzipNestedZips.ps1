Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
  param([string]$zipfile, [string]$outpath)
  [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}



$flag = $true
while($flag)
{
 $zipFiles = Get-ChildItem -Path "C:\temp\" -Recurse | Where-Object {$_.Name -like "*.zip"}

 if($zipFiles.count -eq 0)
 {
    $flag = $false
 }

 elseif($zipFiles.count -gt 0)
 {
    foreach($zipFile in $zipFiles)
    {
     #create the new name without .zip
     $newName = $zipFile.FullName.Replace(".zip", "")

     Unzip $zipFile.FullName $newName

     #remove zip file after unzipping so it doesn't repeat 
     Remove-Item $zipFile.FullName   
    }
 }
 Clear-Variable zipFiles
}