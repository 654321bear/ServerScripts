$DefDNS = "172.20.100.1, 172.20.100.2, 172.20.100.3"$pc_list = get-content "C:\temp\ServerDNS.txt"foreach($pc in $pc_list)    {    $nics = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $pc
    #$pc Filter "IPEnabled=TRUE"    
     foreach($nic in $nics)        {        if($nic.ipaddress -match "10.100.7") # fetch the right nic based on its IP address            {            #$nic.SetDNS($DefDNS)            $nic.DNSServerSearchOrder            $nic.SetDNSServerSearchOrder((172.20.100.1,172.20.100.2,172.20.100.3))            $nic.DNSServerSearchOrder            }        }    }


# .\Set-DefaultDNS.ps1 -ComputerName W791119LT4D21A  |  ft DNSServers, ComputerName 
