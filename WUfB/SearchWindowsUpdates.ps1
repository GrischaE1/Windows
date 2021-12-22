##########################################################################################
# You running this script/function means you will not blame the author(s) if this breaks your stuff. 
# This script/function is provided AS IS without warranty of any kind. Author(s) disclaim all 
# implied warranties including, without limitation, any implied warranties of merchantability or of 
# fitness for a particular purpose. The entire risk arising out of the use or performance of the sample 
# scripts and documentation remains with you. In no event shall author(s) be held liable for any damages 
# whatsoever (including, without limitation, damages for loss of business profits, business interruption, 
# loss of business information, or other pecuniary loss) arising out of the use of or inability to use 
# the script or documentation. Neither this script/function, nor any part of it other than those parts 
# that are explicitly copied from others, may be republished without author(s) express written permission. 
# Author(s) retain the right to alter this disclaimer at any time.
##########################################################################################



##########################################################################################
# Name: WindowsUpdate.ps1
# Version: 0.4
# Date: 18.05.2021
# Created by: Grischa Ernst gernst@vmware.com
#
# Description
# - This Script will provide you a granual control over Window Updates - especially if you using Windows Update for Business
# - This includes
#     1. Download updates at any time, to reduce the installation time
#     2. Install updates during a weekly Maintenace Window
#     3. Download and install updates
# - Updates that require a reboot, will reboot during Maintenace Window - but will not automatically reboot if no MW is configured
# - Registry values in the "HKLM:\SOFTWARE\Policies\Custom\Windows Update" hive are used to configure the script
#
# Caution
# This script is using the PSWindowsUpdate module - which will be installed automatically but requires internet connectivity
#
###################################
# Registry values:
# Name            Value                          Description
# DirectDownload 
#                 True                           Will download update independend of the Maintenace Window
#                 False                          Will not start download before installation
#
# HiddenUpdates
#                 e.g. KB4023057,KB5003173       Hide specific updates to make sure the updates are not installed
#
#
# UnHiddenUpdates
#                 e.g. KB4023057,KB5003173       Un-hide specific updates to make sure the updates are availible for installation again
#
#
# LastInstallationDate 
#                 e.g. 18/05/2021 03:24          Last time where update installation was tried
#
#
#
# MaintenaceWindow
#                 True                           Will install updates only during Maintenace Window
#                 False                          Will install updates whenever possible
# 
#
# MWDay
#                 e.g. 1 for Monday
#                 e.g. 2 for Tuesday             Will install updates only on a spefic day of the week
#
#
# MWStartTime
#                 08:00                          Will start the installation only after this time - make sure you are using 24 hours format
#
#
# MWStopTime
#                 09:30                          Will not install updates after this time - make sure you are using 24 hours format
#
#
# UseMicrosoftUpdate
#                 True                           Will force to use Microsoft Update - will ignore WSUS settings
#                 False                          Will use configured settings
#
##########################################################################################
#                                    Changelog 
#
# 0.4 - added reporting functionality 
# 0.3 - added multi day Maintenance Window support
# 0.2 - changed reboot behavior and fixed Maintenance Window detection + small bug fixes
# 0.1 - Inital creation
##########################################################################################

##########################################################################################
#                                    Param 
#
#define the log folder if needed - otherwise delete it or set it to ""
param(
    [string]$LogPath
)

##########################################################################################
#                                    Functions

function Test-MaintenaceWindow {
    
    $RegSettings = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate'
	

    #Get current time
    $CurrentDate = Get-Date
    $Day = $CurrentDate.DayOfWeek.value__
    $Hour = Get-Date -Format HH 
    $Minute = Get-Date -Format mm

    #Get start time
    $MWStartHour = $RegSettings.MWStartTime.Substring(0, 2)
    $MWStartMinute = $RegSettings.MWStartTime.Remove(0, 3)
    
    #Get stop time
    $MWStopHour = $RegSettings.MWStopTime.Substring(0, 2)
    $MWStopMinute = $RegSettings.MWStopTime.Remove(0, 3)

    #Check if installation day was set - if not, updates will be installed everyday 
    if ($RegSettings.MWDay) {
        if ($RegSettings.MWDay -like "*,*") { $TagetDay = $RegSettings.mwday.Split(",") }
        else { $TagetDay = $RegSettings.mwday }
        
    }
    else {
        $TagetDay = $day
    }

    #Check if current time is in Maintenace Window
    Clear-Variable IsInMaintenaceWindow -Force -ErrorAction SilentlyContinue
    $DayIsInMW = $false

    foreach ($MWDay in $TagetDay) {
       
        if ( $day -eq $MWDay) {
            $DayIsInMW = $true
        }   
        
        if ($DayIsInMW -eq $true) {
            if ($MWStopHour -lt $MWStartHour) {
                if ($Hour -ge $MWStartHour -or $hour -le $MWStopHour) { 
                    if ($hour -ge $MWStartHour -and $Minute -ge $MWStartMinute) {
                        "Case 1"
                        $MWStopHour = "24"
                        $MWStopMinute = "00"
                    }
                }
                if ($Hour -ge $MWStartHour -or $hour -le $MWStopHour) { 
                    if ($hour -le $MWStopHour -and $Minute -le $MWStopMinute) {
                        "Case 2" 
                        $MWStopHour = "00"
                        $MWStopMinute = "00"
                    }
                }

            }
            if ($Hour -ge $MWStartHour -and $hour -le $MWStopHour) {
               
                if ((($hour -eq $MWStartHour -and $Minute -gt $MWStartMinute) -and ($hour -eq $MWStopHour -and $Minute -lt $MWStopMinute))) {        
                    $IsInMaintenaceWindow = $true
                }
                if ($hour -ge $MWStartHour -and $hour -lt $MWStopHour) {
                    $IsInMaintenaceWindow = $true
                }
                if (($hour -ge $MWStartHour -and $hour -eq $MWStopHour) -and $Minute -lt $MWStopMinute) {
                    $IsInMaintenaceWindow = $true
                }
                if (!$IsInMaintenaceWindow) {
                    $IsInMaintenaceWindow = $false
                }
            }
            else { $IsInMaintenaceWindow = $false }
        }
        else { $IsInMaintenaceWindow = $false }
      
    }
    return $IsInMaintenaceWindow
}

function Test-PendingReboot {
    param(
        [bool]$AutomaticReboot
    )


    $PendingRestart = $false
    if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore) { $PendingRestart = $true }
    if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA Ignore) { $PendingRestart = $true }

    if ($PendingRestart -eq $true) {
        Write-Output "Pending Restart - Device will require reboot"

        if ($AutomaticReboot -eq $true) {
            shutdown.exe /r /f /t 120
        }
    }

    return $PendingRestart
}


function Test-UpdateInstallation {
    param(
        [string]$KBNumber,
        $Installationresult
    )

    $VerifyKBInstallation = Get-InstalledWindowsUpdates

    $installationtime = Get-Date -Format "MM/dd/yyyy HH:mm"
 
    if ($Installationresult -contains "Installed" -and $VerifyKBInstallation) {
        "$($KBNumber) installed"
        New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status\KBs' -PropertyType "String" -Name "$($KBNumber) Status" -Value "True" -Force | Out-Null
        New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status\KBs' -PropertyType "String" -Name "$($KBNumber) Date" -Value $installationtime -Force | Out-Null
    }
    else {
        "$($KBNumber) NOT installed"
        New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status\KBs' -PropertyType "String" -Name "$($KBNumber) Status" -Value "False" -Force | Out-Null
    }
}

function Get-InstalledWindowsUpdates {
    #Exported from Get-WUUpdate from the PSWindowsUpdate module
    $UpdateCollection = @()

    $objSession = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session"))#,$Computer))
    $objSearcher = $objSession.CreateUpdateSearcher()
    $TotalHistoryCount = $objSearcher.GetTotalHistoryCount()
   
    If ($TotalHistoryCount -gt 0) {
        $objHistory = $objSearcher.QueryHistory(0, $TotalHistoryCount)
       
        Foreach ($obj in $objHistory) {
            $matches = $null
            $obj.Title -match "KB(\d+)" | Out-Null
                               
            If ($matches -eq $null) {
                Add-Member -InputObject $obj -MemberType NoteProperty -Name KB -Value ""
            } #End If $matches -eq $null
            Else {							
                Add-Member -InputObject $obj -MemberType NoteProperty -Name KB -Value ($matches[0])
            } #End Else $matches -eq $null
                               
            Add-Member -InputObject $obj -MemberType NoteProperty -Name ComputerName -value ""
                               
            $obj.PSTypeNames.Clear()
            $obj.PSTypeNames.Add('PSWindowsUpdate.WUHistory')
           
            If ($obj.kb) {				
                $UpdateCollection += $obj
            }
           
        } #End Foreach $obj in $objHistory
        Write-Progress -Activity "Get update histry for $Computer" -Status "Completed" -Completed
    } #End If $TotalHistoryCount -gt 0
   
    #Get Windows Updates from WMI
    $WMIKBs = Get-WmiObject win32_quickfixengineering |  Select-Object HotFixID -ExpandProperty HotFixID
   
    #Get Windows Updates from DISM
    $DISMKBList = dism /online /get-packages | findstr KB 
   
    $pattern = '(?<=KB).+?(?=~)'
    $DISMKBNumbers = [regex]::Matches($DISMKBList, $pattern).Value
   
    $DISMKBNumbers = @()  
    ForEach ($Number in $DISMKBNumbers) {
        $DISMKBNumbers += "KB$($Number)"
       
    }
   
    $InstalledKBs = ($UpdateCollection.kb + $WMIKBs + $DISMKBNumbers) | Sort-Object -Unique
    return $InstalledKBs
}

function Search-AvailableUpdates {
    param(
        $UseWindowsUpdate = $true
    )
    
    #To make sure to overwrite the WSUS settings
    if ($UseWindowsUpdate -eq $true) {
        #Add Microsoft Update as Update provider
        Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d" -AddServiceFlag 7 -Confirm:$false  | Out-Null
        $AllUpdates = Get-WindowsUpdate -MicrosoftUpdate -IgnoreReboot
    }
    else {
        #Get all updates with the configured update source
        $AllUpdates = Get-WindowsUpdate -IgnoreReboot
    }

    Return $AllUpdates
}

function Install-AvailableUpdates {
    param(
        $DownloadOnly = $false,
        $KBarticleID,
        $UseWindowsUpdate = $true
    )
    

    if ($DownloadOnly -eq $true) {
        Write-Output "Start downloading $($KBarticleID)"
        if ($UseWindowsUpdate -eq $true) {
            $result = Get-WindowsUpdate -Download -KBArticleID $($KBarticleID) -MicrosoftUpdate -Confirm:$false -IgnoreReboot
        }
        if ($UseWindowsUpdate -eq $false) {
            $result = Get-WindowsUpdate -Download -KBArticleID $($KBarticleID) -Confirm:$false -IgnoreReboot
        }
    }
    if ($DownloadOnly -eq $false) {
        Write-Output "Start installation of $($KBarticleID)"
        if ($UseWindowsUpdate -eq $true) {
            $result = Get-WindowsUpdate -Install -KBArticleID $($KBarticleID) -Confirm:$false -MicrosoftUpdate -IgnoreReboot
        }
        if ($UseWindowsUpdate -eq $false) {
            $result = Get-WindowsUpdate -Install -KBArticleID $($KBarticleID) -Confirm:$false -IgnoreReboot
        }
    }
    return $result
}


function Get-NoninstalledUpdates {
    $InstalledKBs = Get-InstalledWindowsUpdates
    $AvailableKBs = (get-windowsupdate -IgnoreReboot).KB
    $Detectiontime = Get-Date -Format "MM/dd/yyyy HH:mm"

    $Items = Get-Item 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status\KBs'
    $StatusKBs = $Items.GetValueNames() | where { $_ -like "*Status*" }  
    
    foreach ($KB in $StatusKBs) { 
           
        $NoninstalledUpdates = Get-ItemPropertyValue 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status\KBs' -Name $KB  | where { $_ -eq "False" -or $_ -like "*Pending*" }
        
        if ($NoninstalledUpdates) {
            if ($KB -eq "False") {
                $NonInstalledKB = $KB.Replace(" Status", "")
            }
            if ($KB -like "*Pending*") {
                $NonInstalledKB = $KB.Replace(" Pending installation", "")
            }

            $KBCheck = $InstalledKBs | Where-Object { $_.HotFixID -eq $NonInstalledKB }
            $AvailableKBCheck = $AvailableKBs | Where-Object { $_ -eq $NonInstalledKB }
            $AvailableKBCheck
            if ($KBCheck) {
                New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status\KBs' -PropertyType "String" -Name "$($NonInstalledKB) Status" -Value "True" -Force | Out-Null
                New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status\KBs' -PropertyType "String" -Name "$($KBNumber) Date" -Value $Detectiontime -Force | Out-Null
            }
            elseif ($AvailableKBCheck) {
                New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status\KBs' -PropertyType "String" -Name "$($NonInstalledKB) Status" -Value "Pending installation" -Force | Out-Null
            }
            else {
                New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status\KBs' -PropertyType "String" -Name "$($NonInstalledKB) Status" -Value "Not Applicable" -Force | Out-Null
            }
        }
    }
}

##########################################################################################
#                                   Define varibales

#define the log folder if needed - otherwise delete it or set it to ""
if ($LogPath) { $Log = $LogPath }

if ($Log) {
    if ((Test-Path (Split-Path -Parent $Log)) -eq $false) { New-Item (Split-Path -Parent $Log) -ItemType Directory }
    Start-Transcript -Path $Log -Append
}
Write-Output "###############################################################################"
Write-Output "Start Windows Update on $(Get-Date -Format "dd/MM/yyyy HH:mm")"

Try { Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -ErrorAction Stop } Catch {}

#Enable this if you want to install the latest version of PSWindowsUpdate
<#
    $PackageProvider = Get-PackageProvider -ListAvailable
    $NuGetInstalled = $false
    foreach ($item in $PackageProvider.name)
    {
    if($item -eq “NuGet”)
    {
        $NuGetInstalled = $tru
    }
    }
    if($NuGetInstalled = $false)
    {
    Install-PackageProvider NuGet -Force
    }
#>

Import-Module PSWindowsUpdate

#####
#Status Codes
#------- Update is requested
#-D----- Update is downloaded
#--I---- Update is installed
#---H--  Update is hidden
#-----U- Update is uninstallable
#------B Update is beta


#Get settings from Registry
$Settings = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate' -ErrorAction SilentlyContinue

#Create Status registry keys
if (!(Test-Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status')) {
    New-Item 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status' -Force | Out-Null
}
if (!(Test-Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status\KBs')) {
    New-Item 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status\KBs' -Force | Out-Null
}

#Hide unwanted updates
If ($settings.HiddenUpdates) {
    Hide-WindowsUpdate -KBArticleID $settings.HiddenUpdates -Hide -Confirm:$false
}

#Allow hidden update again
If ($settings.UnHiddenUpdates) {
    UnHide-WindowsUpdate -KBArticleID $settings.UnHiddenUpdates -Confirm:$false
}
  
#Get all updates with the configured update source
$AllUpdates = Search-AvailableUpdates -UseWindowsUpdate $($Settings.UseMicrosoftUpdate)
  

#Check detected but not installed updates
Get-NoninstalledUpdates


Write-output "Pending Update count: $($AllUpdates.Count)"

#run download and installation if updates are available 
if ($AllUpdates) {
    #If Download is independent of installation - Download all Updates
    If ($Settings.DirectDownload -eq $True) {
        Write-Output "Starting Download"
        #get all updates that are not downloaded
        $NotDonwloadedUpdates = $AllUpdates | Where-Object { $_.Status -notlike "*D*" }
        foreach ($Update in $NotDonwloadedUpdates) {
            $UpdateKB = $update.KB
        
            $Result = Install-AvailableUpdates -DownloadOnly $true -KBarticleID $UpdateKB -UseWindowsUpdate $($Settings.UseMicrosoftUpdate)

            #Check if download was successfull
            if ($result.result -contains "Downloaded") {
                "KB $($UpdateKB) downloaded"
            }
            #retry download
            else {
                $Result = Install-AvailableUpdates -DownloadOnly $true -KBarticleID $UpdateKB -UseWindowsUpdate $($Settings.UseMicrosoftUpdate)
            
                #Check again download status
                if ($result.result -contains "Downloaded") {
                    "KB $($UpdateKB) downloaded"
                }
                else {
                    "KB $($UpdateKB) NOT downloaded"
                }
            }
        }
        Write-Output "Download finished"
    }
  

    #Install Updates
    #Check if Maintenace Window is enabled
    if ($Settings.MaintenaceWindow -eq $true) {
  
        Write-Output "Maintenace Window detected"
        if ([bool](Test-MaintenaceWindow) -eq $true) {
            Write-Output "Running during Maintenace Window"
            Test-PendingReboot -AutomaticReboot $true | Out-Null

            $InstallableUpdates = Search-AvailableUpdates -UseWindowsUpdate $($Settings.UseMicrosoftUpdate)
            foreach ($Update in $InstallableUpdates) {
                $UpdateKB = $update.KB
                    
                if ([bool](Test-MaintenaceWindow) -eq $true) {
                    $Installation = Install-AvailableUpdates -DownloadOnly $false -KBarticleID $UpdateKB -UseWindowsUpdate $($Settings.UseMicrosoftUpdate)
                        
                    Test-UpdateInstallation -KBNumber $UpdateKB -Installationresult $installation.result
                }
                else { break }
            }
        
            if ([bool](Test-MaintenaceWindow) -eq $true) {
                Test-PendingReboot -AutomaticReboot $true | Out-Null
            }       
        }
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate' -Name 'LastInstallationDate' -Value $(Get-Date -Format "dd/MM/yyyy HH:mm")
    }
  
    #If no maintenance window is configured, just install the updates at any time
    else {
        Write-Output "Starting installation without Maintenace Window"

        $InstallableUpdates = Search-AvailableUpdates -UseWindowsUpdate $($Settings.UseMicrosoftUpdate)
            
        foreach ($Update in $InstallableUpdates) {
            $UpdateKB = $update.KB
            $Installation = Install-AvailableUpdates -DownloadOnly $false -KBarticleID $UpdateKB -UseWindowsUpdate $($Settings.UseMicrosoftUpdate)
            
            Test-UpdateInstallation -KBNumber $UpdateKB -Installationresult $installation.result
        }
    
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate' -Name 'LastInstallationDate' -Value $(Get-Date -Format "dd/MM/yyyy HH:mm")
    }
}

#Check if  Reboot pending   
$RebootRequired = Test-PendingReboot -AutomaticReboot $false

if ($RebootRequired -eq $true) {
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status' -PropertyType "String" -Name "PendingReboot" -Value "True" -Force | Out-Null
}
else {
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status' -PropertyType "String" -Name "PendingReboot" -Value "False" -Force | Out-Null
}

#Resetting counter
$UpdateCount = 0
$UpdateRollupsCount = 0
$DefinitionUpdatesCount = 0
$UpgradesCount = 0
$SecurityUpdatesCount = 0
$InstallableUpdates = ""

#Check missing updates
$InstallableUpdates = Search-AvailableUpdates -UseWindowsUpdate $($Settings.UseMicrosoftUpdate)
 

if ($InstallableUpdates) {
    foreach ($update in $InstallableUpdates) {
        $UpdateCategory = $Update.Categories._NewEnum.name | Select-Object  -First 1

        switch ($UpdateCategory) {
            "Updates" { $UpdateCount = $UpdateCount + 1 }
            "Update Rollups" { $UpdateRollupsCount = $UpdateRollupsCount + 1 }
            "Definition Updates" { $DefinitionUpdatesCount = $DefinitionUpdatesCount + 1 }
            "Upgrades" { $UpgradesCount = $UpgradesCount + 1 }
            "Security Updates" { $SecurityUpdatesCount = $SecurityUpdatesCount + 1 }
        }

        New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status\KBs' -PropertyType "String" -Name "$($update.KB) Status" -Value "Pending installation" -Force | Out-Null

    }
      
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status' -PropertyType "String" -Name "Total Missing Updates" -Value $($InstallableUpdates.count) -Force | Out-Null
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status' -PropertyType "String" -Name "Open Pending Updates" -Value "True" -Force | Out-Null
}
else {
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status' -PropertyType "String" -Name "Total Missing Updates" -Value $($InstallableUpdates.count) -Force | Out-Null
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status' -PropertyType "String" -Name "Open Pending Updates" -Value "False" -Force | Out-Null
}

#Reporting the current installation count to the registry
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status' -PropertyType "String" -Name "Pending Updates" -Value $UpdateCount -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status' -PropertyType "String" -Name "Pending Update Rollups" -Value $UpdateRollupsCount -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status' -PropertyType "String" -Name "Pending Definition Updates" -Value $DefinitionUpdatesCount -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status' -PropertyType "String" -Name "Pending Feature Upgrades" -Value $UpgradesCount -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status' -PropertyType "String" -Name "Pending Security Updates" -Value $SecurityUpdatesCount -Force | Out-Null

 

#Report all installed updates 
$InstalledUpdates = Get-InstalledWindowsUpdates

New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status' -PropertyType "String" -Name "Installed KBs" -Value $InstalledUpdates -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status' -PropertyType "String" -Name "Total Installed KBs" -Value $($InstalledUpdates.Count) -Force | Out-Null

Write-Output "Stop Windows Update on $(Get-Date -Format "dd/MM/yyyy HH:mm")"
Write-Output "###############################################################################"
if ($Log) { Stop-Transcript }
