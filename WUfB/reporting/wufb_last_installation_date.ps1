$LastInstallationDate = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate -Name "LastInstallationDate"
Return $LastInstallationDate.LastInstallationDate