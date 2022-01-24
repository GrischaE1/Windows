$PendingUpdateRollups = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status -Name "Pending Update Rollups"
Return $PendingUpdateRollups.'Pending Update Rollups'