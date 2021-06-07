$ComboBoxMMW_SelectedIndexChanged = {
 if($ComboBoxMMW.SelectedItem -eq "false"){$DateTimePickerStart.enabled = $false; $DateTimePickerEnd.enabled = $false; $ComboBoxDay.enabled = $false}
 if($ComboBoxMMW.SelectedItem -eq "true"){$DateTimePickerStart.enabled = $true; $DateTimePickerEnd.enabled = $true; $ComboBoxDay.enabled = $true}
}


$Button1_Click = {

        #Map variables
        $DirectDownload = $ComboBoxDL.SelectedItem
        $HiddenUpdates = $TextBox3.Text
        $UnHiddenUpdates = $TextBox4.Text
        $MaintenaceWindow = $ComboBoxMMW.SelectedItem
        $MWDay = $ComboBoxDay.SelectedItem
        $MWStartTime = $DateTimePickerStart.Value.ToString("HH:mm")
        $MWStopTime = $DateTimePickerEnd.Value.ToString("HH:mm")
        $UseMicrosoftUpdate = $ComboBoxMSUpdate.SelectedItem
       
#Validation Check
$wshell = New-Object -ComObject Wscript.Shell
if(!$UseMicrosoftUpdate){$wshell.Popup("Please select Microsoft Update value",0,"Error",16)
exit}
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

    #Day mapping for Maintenace Window
    $day = $ComboBoxDay.SelectedItem
    if($day -like "*day")
    {
        switch ( $day )
        {
            'Monday'    { $TargetDay =  1   }
            'Tuesday'   { $TargetDay =  2   }
            'Wednesday' { $TargetDay =  3   }
            'Thursday'  { $TargetDay =  4   }
            'Friday'    { $TargetDay =  5   }
            'Sunday'    { $TargetDay =  6   }
            'Saturday'  { $TargetDay =  7   }
            default { 'None' }
        }
        Write-Output "Day Value: $($TargetDay)"  | Out-File C:\Temp\Test.txt -append 
        $result
    }

    #gernate GUID
    $guid1 = [guid]::NewGuid()
    $guid2 = [guid]::NewGuid()
    


Write-host "$($DateTimePickerStart.Value.ToString("HH:mm"))"

    #Make sure settings are correct configured
    if(!$HiddenUpdates){$HiddenUpdates = '&quot;&quot;'}
    if(!$UnHiddenUpdates){$UnHiddenUpdates = '&quot;&quot;'}
    if($MWStartTime -eq "00:00" -and $MWStopTime -eq "00:00"){$MWStartTime = '&quot;&quot;' 
    $MWStopTime = '&quot;&quot;'}
    if($MWDay -eq "none"){$MWDay = '&quot;&quot;'}
    if($MaintenaceWindow -eq "false"){
        $MWDay = '&quot;&quot;'
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
    New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate -Name MWDay -PropertyType String -Value $($MWDay);
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
}
}

#Run the GUI
Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'ProfileCreator.designer.ps1')
$Form1.ShowDialog()