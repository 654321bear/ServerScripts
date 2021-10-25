$DefDNS = "172.20.100.1, 172.20.100.2, 172.20.100.3"$pc_list = get-content "C:\temp\ServerDNS.txt"

$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration -computername $pc_list |where{$_.IPEnabled -eq “TRUE”}
  Foreach($NIC in $NICs) {
 $NIC.SetDNSServerSearchOrder($DefDNS)
 $NIC.SetDynamicDNSRegistration(“TRUE”)
}