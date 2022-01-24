$PendingSecurityUpdates = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status -Name "Pending Security Updates"
Return $PendingSecurityUpdates.'Pending Security Updates'