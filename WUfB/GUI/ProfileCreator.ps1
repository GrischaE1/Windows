
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
# Name: ProfileCreator.ps1
# Version: 0.3
# Date: 18.05.2021
# Created by: Grischa Ernst gernst@vmware.com
#
#
##########################################################################################

##########################################################################################
#                                    Changelog 
#
# 0.3 - Bug fix for multi day selection
# 0.2 - Added multi day selection for MW
# 0.1 - Inital creation
##########################################################################################


$ComboBoxDay_SelectedIndexChanged = {
    if($ComboBoxDay.SelectedItem -eq "Daily"){$ListBoxDay.enabled = $false; $ListBoxDay.ClearSelected()}
    if($ComboBoxDay.SelectedItem -eq "Selected Day(s)"){$ListBoxDay.enabled = $true}
    }
    $ComboBoxMMW_SelectedIndexChanged = {
     if($ComboBoxMMW.SelectedItem -eq "false"){$DateTimePickerStart.enabled = $false; $DateTimePickerEnd.enabled = $false; $ComboBoxDay.enabled = $false;$ListBoxDay.enabled = $false}
     if($ComboBoxMMW.SelectedItem -eq "true"){$DateTimePickerStart.enabled = $true; $DateTimePickerEnd.enabled = $true; $ComboBoxDay.enabled = $true}
    }
    
    
    $Button1_Click = {
    
            #Map variables
            $DirectDownload = $ComboBoxDL.SelectedItem
            $HiddenUpdates = $TextBox3.Text
            $UnHiddenUpdates = $TextBox4.Text
            $MaintenaceWindow = $ComboBoxMMW.SelectedItem
            $MWDay = @($ListBoxDay.SelectedItems)
            $MWStartTime = $DateTimePickerStart.Value.ToString("HH:mm")
            $MWStopTime = $DateTimePickerEnd.Value.ToString("HH:mm")
            $UseMicrosoftUpdate = $ComboBoxMSUpdate.SelectedItem
    
      
    #Validation Check
    $wshell = New-Object -ComObject Wscript.Shell
    if(!$UseMicrosoftUpdate){$wshell.Popup("Please select Microsoft Update value",0,"Error",16)}
    if(!$DirectDownload){$wshell.Popup("Please select direct download value",0,"Error",16)}
    if(!$MaintenaceWindow){$wshell.Popup("Please select MaintenaceWindow value",0,"Error",16)}
    
    if($MaintenaceWindow -eq "True")
    {
        if($MWStartTime -ge $MWStopTime)
        {
            $wshell.Popup("Start time has to be greater then end time",0,"Error",16)
        }
        if(!$MWDay)
        {
            $wshell.Popup("Please select day",0,"Error",16)
        }
    
    }
        $convertedDays = @()
        $selectedDays = ""
        #Day mapping for Maintenace Window
        if($MWDay)
        {
            foreach($day in $MWDay)
            {
                switch ( $day )
                {
                    'Monday'    { $TargetDay =  1   }
                    'Tuesday'   { $TargetDay =  2   }
                    'Wednesday' { $TargetDay =  3   }
                    'Thursday'  { $TargetDay =  4   }
                    'Friday'    { $TargetDay =  5   }           
                    'Saturday'  { $TargetDay =  6   }
                    'Sunday'    { $TargetDay =  7   }
                    default { 'None' }
                }
               
                $convertedDays +=  $TargetDay
            
            }
        }
        else{$selectedDays = "None"}
        
        if($convertedDays.count -ge 1)
        {
            [string]$selectedDays = $convertedDays[0]
            ForEach($day in $convertedDays)
            {
                if($day -ne $convertedDays[0])
                {
                    [string]$selectedDays = "$selectedDays,$day"
                }
            }
        }
        $selectedDays | Out-File C:\Temp\Validation1.txt -force
    
    
    
    #gernate GUID
    $guid1 = [guid]::NewGuid()
    $guid2 = [guid]::NewGuid()
    
    
    
    Write-host "$($DateTimePickerStart.Value.ToString("HH:mm"))"
    
    #Make sure settings are correct configured
    if(!$HiddenUpdates){$HiddenUpdates = '&quot;&quot;'}
    if(!$UnHiddenUpdates){$UnHiddenUpdates = '&quot;&quot;'}
    if($MWStartTime -eq "00:00" -and $MWStopTime -eq "00:00"){$MWStartTime = '&quot;&quot;' 
    $MWStopTime = '&quot;&quot;'}
    if($selectedDays -eq "none"){$selectedDays = '&quot;&quot;'}
    if($MaintenaceWindow -eq "false"){
        $selectedDays = '&quot;&quot;'
        $MWStartTime = '&quot;&quot;'
        $MWStopTime = '&quot;&quot;'
    }
    
    #Create the CSP Profile
    
    $temp = '<wap-provisioningdoc id="$($guid1)" name="customprofile">
    <characteristic type="com.airwatch.winrt.powershellcommand" uuid="$($guid2)">
    <parm name="PowershellCommand" value="Invoke-Command -ScriptBlock {
    New-Item HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate -Force;
    New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate -Name DirectDownload -PropertyType String -Value $($DirectDownload);
    New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate -Name HiddenUpdates -PropertyType String -Value $($HiddenUpdates);
    New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate -Name UnHiddenUpdates -PropertyType String -Value  $($UnHiddenUpdates);
    New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate -Name LastInstallationDate -PropertyType String -Value &quot;&quot;;
    New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate -Name MaintenaceWindow -PropertyType String -Value $($MaintenaceWindow);
    New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate -Name MWDay -PropertyType String -Value &quot;$($selectedDays)&quot;;
    New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate -Name MWStartTime -PropertyType String -Value  $($MWStartTime);
    New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate -Name MWStopTime -PropertyType String -Value $($MWStopTime);
    New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate -Name UseMicrosoftUpdate -PropertyType String -Value $($UseMicrosoftUpdate   )  
    }"/>
    </characteristic>
    </wap-provisioningdoc>
    '
    #Export to XML
    
    if($XMLCheckBox.checked -eq $true)
    {
    Add-Type -AssemblyName System.Windows.Forms
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog 
    [void]$FolderBrowser.ShowDialog()
    
    $OutPut = $ExecutionContext.InvokeCommand.ExpandString($temp)
    $OutPut  | Out-File "$($FolderBrowser.SelectedPath)\WindowsUpdateCustomCSP.xml" -Force
    }
    
    
    #copy to clipboard
    if($ClipCheckBox.checked -eq $true)
    {
        $OutPut = $ExecutionContext.InvokeCommand.ExpandString($temp)
        $OutPut  | Clip
        #$MWDay | Clip
    }
    }
    
    #Run the GUI
    Add-Type -AssemblyName System.Windows.Forms
    . (Join-Path $PSScriptRoot 'ProfileCreator.designer.ps1')
    $Form1.ShowDialog()
    
