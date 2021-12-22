
##########################################################################################
#                                    Param 
#
#define the log folder if needed - otherwise delete it or set it to ""
param(
		[string]$LogPath,
        [string]$InstallDir,
        [int]$UpdateInterval
	)


#Create action
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "-ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -file ""$($InstallDir)\SearchWindowsUpdates.ps1"" -LogPath ""$($LogPath)\WindowsUpdate.log""" 

#create triggers
$starttime=(get-date)
$TimeSpan = New-TimeSpan -Minutes $UpdateInterval

$trigger = @()
$trigger += New-ScheduledTaskTrigger -Once -At $startTime -RepetitionInterval $TimeSpan
$trigger += New-ScheduledTaskTrigger -AtStartup

#Use System account
$User = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest

#Settings to make sure the task can run everytime
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances Queue -DontStopOnIdleEnd -RunOnlyIfNetworkAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

#Create the new scheduled task
Register-ScheduledTask -TaskName "Search Windows Updates" -Action $action -Trigger $trigger -Principal $user  -Settings $settings –Force


New-Item -Path $InstallDir -Name 'CustomUpdate' -ItemType Directory -Force
Copy-Item "$PSScriptRoot\SearchWindowsUpdates.ps1" -Destination $InstallDir -Force
Copy-Item "$PSScriptRoot\PSWindowsUpdate" -Destination 'C:\Program Files\WindowsPowerShell\Modules\' -Recurse -Force
