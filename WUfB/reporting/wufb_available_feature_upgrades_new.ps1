$PendingFeatureUpgrades = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status -Name "Pending Feature Upgrades"
Return $PendingFeatureUpgrades.'Pending Feature Upgrades'