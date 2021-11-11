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
# Name: Profile_Creator.ps1
# Version: 0.1
# Date: 11.11.2021
# Created by: Grischa Ernst gernst@vmware.com
#
# Description
# - This Script will a custom device profile to uninstall Windows apps
# - Just export the App names you want to uninstall via PowerShell:
#
#  Get-AppxPackage | Where-Object {$_.NonRemovable -eq $false -and $_.IsFramework -eq $false} | select PackageFamilyName
#
# Copy and paste the PackageFamilyName to a txt file and change the $inputfile to your file
# If needed change the outputfile
#
# Caution
# This script is using the PSWindowsUpdate module - which will be installed automatically but requires internet connectivity
#
###################################


$inputfile = "C:\Temp\Windows11_21H2_Get-AppxPackage.txt"

$Apps = Get-Content $inputfile

foreach($app in $apps)
{
    $guid = [guid]::NewGuid()

    $RemoveApp = "<Delete>
        <CmdID>$($guid.Guid)</CmdID>
        <Item>
            <Target>   
                <LocURI>./Device/Vendor/MSFT/EnterpriseModernAppManagement/AppManagement/AppStore/$($app)</LocURI>
            </Target>
        </Item>
    </Delete>
        "

    $temp += $RemoveApp

}
    
    #Export to XML
    $OutPut = $ExecutionContext.InvokeCommand.ExpandString($temp)
    $OutPut  | Out-File "C:\Temp\WindowsRemoveApps.xml" -Force
