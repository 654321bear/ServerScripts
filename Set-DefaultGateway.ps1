$DefGateway = "192.168.1.1"$pc_list = get-content "c:\pclist.txt"foreach($pc in $pc_list)    {    $nics = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName 
    $pc -Filter "IPEnabled=TRUE"    
     foreach($nic in $nics)        {        if($nic.ipaddress -match "192.168.1.") # fetch the right nic based on its IP address            {            $nic.SetGateways($DefGateway)            }        }    }
