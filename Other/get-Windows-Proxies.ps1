#INET Proxy
$INET = Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -ErrorAction SilentlyContinue

if($INET)
{
 if($INET.ProxyEnable -eq '1')
 {
    $INETDetected = $true
    $INETServer = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyServer).ProxyServer
    
    Write-Output "INET Proxy detected and enabled" 
    Write-Output "INET Configuration:"
    Write-Output $INETServer 
    Write-Output ""

 }else{$INETDetected = $false}
}else{$INETDetected = $false}


#WINHTTP Proxy
$WINHTTP = netsh winhttp show proxy

if($WINHTTP[3] -like "*no proxy server*")
{
     $WINHTTPDetected = $false
}
else
{
    $WINHTTPDetected = $true
    
    Write-Output "WINHTTP Proxy detected and enabled" 
    Write-Output "WINHTTP Configuration:"
    Write-Output $WINHTTP[3]
    Write-Output ""
}


#BITS Proxy
$BITSLOCALSYSTEM = bitsadmin /util /getieproxy LOCALSYSTEM
$BITSNETWORKSERVICE = bitsadmin /util /getieproxy NETWORKSERVICE
$BITSLOCALSERVICE = bitsadmin /util /getieproxy LOCALSERVICE

if($BITSLOCALSERVICE[8] -like "*autodetect*" -and $BITSNETWORKSERVICE[8] -like "*autodetect*" -and $BITSLOCALSERVICE[8] -like "*autodetect*")
{
     $BITSDetected = $false
}
else
{
    $BITSDetected = $true
    Write-Output "BITS Proxy detected and enabled" 
    Write-Output "BITS Configuration:"
    Write-Output $BITSLOCALSYSTEM[5]
    Write-Output $BITSLOCALSYSTEM[8]

    Write-Output $BITSNETWORKSERVICE[5]
    Write-Output $BITSNETWORKSERVICE[8]

    Write-Output $BITSLOCALSERVICE[5]
    Write-Output $BITSLOCALSERVICE[8]
    Write-Output ""
}

if($INETDetected -eq $false -and $WINHTTPDetected -eq $false -and $BITSDetected -eq $false)
{
    Write-Output "No Proxy detected"     
}
