$PendingDefinitionUpdates = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status -Name "Pending Definition Updates"
Return $PendingDefinitionUpdates.'Pending Definition Updates'