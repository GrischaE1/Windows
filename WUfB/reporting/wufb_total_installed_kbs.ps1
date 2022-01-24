$TotalInstalledKBs = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status -Name "Total Installed KBs"
Return $TotalInstalledKBs.'Total Installed KBs'