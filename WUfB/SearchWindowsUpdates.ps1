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
# Version: 0.2
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
    
    $RegSettings  =  Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate'
	

    #Get current time
    $CurrentDate = Get-Date
    $Day = $CurrentDate.DayOfWeek.value__
    $Hour = Get-Date -Format HH 
    $Minute = Get-Date -Format mm

    #Get start time
    $MWStartHour = $RegSettings.MWStartTime.Substring(0,2)
    $MWStartMinute = $RegSettings.MWStartTime.Remove(0,3)
    
    #Get stop time
    $MWStopHour = $RegSettings.MWStopTime.Substring(0,2)
    $MWStopMinute = $RegSettings.MWStopTime.Remove(0,3)

    #Check if installation day was set - if not, updates will be installed everyday 
    if($RegSettings.MWDay)
    {
      $TagetDay = $RegSettings.mwday
    }
    else
    {
      $TagetDay = $day
    }

    #Check if current time is in Maintenace Window
    Clear-Variable IsInMaintenaceWindow -Force -ErrorAction SilentlyContinue
    if( $day -eq $TagetDay)
    {
        if($Hour -ge $MWStartHour -and $hour -le $MWStopHour)
        {
            if((($hour -eq $MWStartHour -and $Minute -gt $MWStartMinute) -and ($hour -eq $MWStopHour -and $Minute -lt $MWStopMinute)))
            {        
                $IsInMaintenaceWindow = $true
            }
            if($hour -ge $MWStartHour -and $hour -lt $MWStopHour)
            {
                $IsInMaintenaceWindow = $true
            }
            if(($hour -ge $MWStartHour -and $hour -eq $MWStopHour) -and $Minute -lt $MWStopMinute)
            {
                $IsInMaintenaceWindow = $true
            }
           if(!$IsInMaintenaceWindow)
           {
                $IsInMaintenaceWindow = $false
           }
        }else {$IsInMaintenaceWindow = $false}
    }else {$IsInMaintenaceWindow = $false}
    return $IsInMaintenaceWindow

}

function Test-PendingReboot {
    $PendingRestart = $false
    if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore) { $PendingRestart = $true }
    if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA Ignore) { $PendingRestart = $true }

    if($PendingRestart -eq $true)
    {
        shutdown.exe /r /f /t 120

        Start-Sleep -Seconds 120
    }
}

##########################################################################################
#                                   Define varibales

#define the log folder if needed - otherwise delete it or set it to ""
if($LogPath){$Log = $LogPath}

if($Log){
if((Test-Path (Split-Path -Parent $Log)) -eq $false){New-Item (Split-Path -Parent $Log) -ItemType Directory}
Start-Transcript -Path $Log -Append}
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
else{
Get-PackageProvider -Name NuGet -Force
Write-Output “NuGet is already installed”}

$ModuleInstalled = Get-Module PSWindowsUpdate
if(!$ModuleInstalled)
{
   Install-Module -Name PSWindowsUpdate -Force
}
else{Write-Output “PSWindowsUpdate Module is already installed”}

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
  $Settings =  Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate'

  #Hide unwanted updates
  If($settings.HiddenUpdates)
  {
     Hide-WindowsUpdate -KBArticleID $settings.HiddenUpdates -Hide -Confirm:$false
  }

  #Allow hidden update again
  If($settings.UnHiddenUpdates)
  {
     UnHide-WindowsUpdate -KBArticleID $settings.UnHiddenUpdates -Confirm:$false
  }
  
  #To make sure to overwrite the WSUS settings
  if($Settings.UseMicrosoftUpdate -eq $true)
  {
    #Add Microsoft Update as Update provider
    Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d" -AddServiceFlag 7 -Confirm:$false  | Out-Null
    $AllUpdates = Get-WindowsUpdate -MicrosoftUpdate -IgnoreReboot
  }
  else
  {
      #Get all updates with the configured update source
      $AllUpdates = Get-WindowsUpdate -IgnoreReboot
  }

  #If Download is independent of installation - Download all Updates
  If($Settings.DirectDownload -eq $True)
  {
    Write-Output "Starting Download"
    #get all updates that are not downloaded
    $NotDonwloadedUpdates = $AllUpdates | Where-Object {$_.Status -notlike "*D*"}
    foreach($Update in $NotDonwloadedUpdates)
    {
        $UpdateKB = $update.KB
        
        #Use Microsoft Update as update source
        if($Settings.UseMicrosoftUpdate -eq $true)
        {
            $result = Get-WindowsUpdate -Download -KBArticleID $UpdateKB -MicrosoftUpdate -Confirm:$false -IgnoreReboot
        }
        else
        {
            $result = Get-WindowsUpdate -Download -KBArticleID $UpdateKB -Confirm:$false -IgnoreReboot
        }

        #Check if download was successfull
        if($result.result -contains "Downloaded")
        {
            "KB $($UpdateKB) downloaded"
        }
        #retry download
        else
        {
            #Use Microsoft Update as update source
            if($Settings.UseMicrosoftUpdate -eq $true)
            {
                $result = Get-WindowsUpdate -ForceDownload -KBArticleID $UpdateKB -MicrosoftUpdate -Confirm:$false -IgnoreReboot
            }
            else
            {
                $result = Get-WindowsUpdate -ForceDownload -KBArticleID $UpdateKB -Confirm:$false -IgnoreReboot
            }
            
            #Check again download status
            if($result.result -contains "Downloaded")
            {
                "KB $($UpdateKB) downloaded"
            }
            else
            {
                "KB $($UpdateKB) NOT downloaded"
            }
        }
    }
    Write-Output "Download finished"
  }
  

  #Install Updates
  #Check if Maintenace Window is enabled
  if($Settings.MaintenaceWindow -eq $true)
  {
  
    Write-Output "Maintenace Window detected"
    if([bool](Test-MaintenaceWindow) -eq $true)
    {
        Write-Output "Running during Maintenace Window"
        Test-PendingReboot

        #Force to use Microsoft update - this will also overwrite current WSUS settings
        if($Settings.UseMicrosoftUpdate -eq $true)
        {
            $InstallableUpdates = Get-WindowsUpdate -MicrosoftUpdate
            foreach($Update in $InstallableUpdates)
            {
                $UpdateKB = $update.KB
                
                if([bool](Test-MaintenaceWindow) -eq $true)
                {
                    $Installation =  Install-WindowsUpdate -Install -KBArticleID $UpdateKB -Confirm:$false -MicrosoftUpdate -IgnoreReboot
                    
                    if($Installation.result -contains "Installed")
                    {
                        "$($UpdateKB) installed"
                    }
                    else
                    {
                        "$($UpdateKB) NOT installed"
                    }
                }
                else {break}
            }
            if([bool](Test-MaintenaceWindow) -eq $true)
            {
                Test-PendingReboot
            }
        }
        #Use configured settings
        else
        {
            $InstallableUpdates = Get-WindowsUpdate 
            foreach($Update in $InstallableUpdates)
            {
                $UpdateKB = $update.KB
        
                if([bool](Test-MaintenaceWindow) -eq $true)
                {
                    $Installation =  Install-WindowsUpdate -Install -KBArticleID $UpdateKB -Confirm:$false -MicrosoftUpdate -IgnoreReboot
                    
                    if($Installation.result -contains "Installed")
                    {
                        "$($UpdateKB) installed"
                    }
                    else
                    {
                        "$($UpdateKB) NOT installed"
                    }
                }
                else {break}
            }
            if([bool](Test-MaintenaceWindow) -eq $true)
            {
                Test-PendingReboot
            }       
        }
          Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate' -Name 'LastInstallationDate' -Value $(Get-Date -Format "dd/MM/yyyy HH:mm")
    }
  }
  #If no maintenance window is configured, just install the updates at any time
  else
  {
        Write-Output "Starting installation without Maintenace Window"
        if($Settings.UseMicrosoftUpdate -eq $true)
        {
            $InstallableUpdates = Get-WindowsUpdate -MicrosoftUpdate
            
            foreach($Update in $InstallableUpdates)
            {
                $UpdateKB = $update.KB
                $Installation =  Install-WindowsUpdate -Install -KBArticleID $UpdateKB -Confirm:$false -MicrosoftUpdate -IgnoreReboot
            
                if($Installation.result -contains "Installed")
                {
                    "$($UpdateKB) installed"
                }
                else
                {
                    "$($UpdateKB) NOT installed"
                }
            }
        }
        else
        {
            $InstallableUpdates = Get-WindowsUpdate

            foreach($Update in $InstallableUpdates)
            {
                $UpdateKB = $update.KB
                $Installation =  Install-WindowsUpdate -Install -KBArticleID $UpdateKB -Confirm:$false -MicrosoftUpdate -IgnoreReboot
            
                if($Installation.result -contains "Installed")
                {
                    "$($UpdateKB) installed"
                }
                else
                {
                    "$($UpdateKB) NOT installed"
                }
            }
        }
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate' -Name 'LastInstallationDate' -Value $(Get-Date -Format "dd/MM/yyyy HH:mm")
  }

Write-Output "Stop Windows Update on $(Get-Date -Format "dd/MM/yyyy HH:mm")"
Write-Output "###############################################################################"
if($Log){Stop-Transcript}
