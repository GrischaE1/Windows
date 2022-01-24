$TotalMissingUpdates = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status -Name "Total Missing Updates"
Return $TotalMissingUpdates.'Total Missing Updates'