#If you want do deploy policy registry settings to the current user, you need this script to set it to ALL users that were logged on to the device.
#make sure you encode the script before deploying it via CSP


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
# Name: CurrentUser_PoliciesHive.ps1
# Version: 0.1
# Date: 26.01.2021
# Created by: Grischa Ernst gernst@vmware.com
#
# Description
# If you want do deploy policy registry settings to the current user, you need this script to set it to ALL users that were logged on to the device.
# make sure you encode the script before deploying it via CSP
#
##########################################################################################
#                                    Changelog 
#
# 0.1 - inital creation
##########################################################################################



# check if HKU branch is already mounted as a PSDrive. If so, remove it first
$HKU = Get-PSDrive HKU -ea silentlycontinue
#check HKU branch mount status
if (!$HKU ) {
 # recreate a HKU as a PSDrive and navigate to it
 New-PSDrive -Name HKU -PsProvider Registry HKEY_USERS | out-null
}
$Users = (Get-ChildItem HKU:\ | Where-Object {$_.Name -notlike “*S-1-5-18*” -and $_.Name -notlike “*S-1-5-19*” -and $_.Name -notlike “*S-1-5-20*” -and $_.Name -notlike “*.DEFAULT*” -and $_.Name -notlike “*_Classes*“}).Name
foreach ($UserSID in $Users)
{
    $SID = $UserSID.Remove(0,11)
    $path = “HKU:\$($SID)\Software\Policies\Google\Chrome”
    $RegCheck = Test-Path $path
    if($RegCheck -eq $false)
    {
        New-Item -Path $path -Force
    }
    New-ItemProperty -Path $path -Name “ApplicationLocaleValue” -PropertyType STRING -Value “en-AU” -Force
}
