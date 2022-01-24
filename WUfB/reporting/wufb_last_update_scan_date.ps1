$LastScanDate = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status -Name "Last Update Scan"
Return $LastScanDate.'Last Update Scan'