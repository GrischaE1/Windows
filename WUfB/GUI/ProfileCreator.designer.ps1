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

$Form1 = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Button]$ButtonCreate = $null
[System.Windows.Forms.ComboBox]$ComboBoxDay = $null
[System.Windows.Forms.ComboBox]$ComboBoxMMW = $null
[System.Windows.Forms.ComboBox]$ComboBoxDL = $null
[System.Windows.Forms.Label]$Label1 = $null
[System.Windows.Forms.Label]$Label2 = $null
[System.Windows.Forms.Label]$Label3 = $null
[System.Windows.Forms.Label]$Label4 = $null
[System.Windows.Forms.Label]$Label5 = $null
[System.Windows.Forms.TextBox]$TextBox3 = $null
[System.Windows.Forms.TextBox]$TextBox4 = $null
[System.Windows.Forms.Label]$Label6 = $null
[System.Windows.Forms.Label]$Label7 = $null
[System.Windows.Forms.ComboBox]$ComboBoxMSUpdate = $null
[System.Windows.Forms.Label]$Label8 = $null
[System.Windows.Forms.CheckBox]$ClipCheckBox = $null
[System.Windows.Forms.CheckBox]$XMLCheckBox = $null
[System.Windows.Forms.DateTimePicker]$DateTimePickerStart = $null
[System.Windows.Forms.DateTimePicker]$DateTimePickerEnd = $null
[System.Windows.Forms.ListBox]$ListBoxDay = $null
[System.Windows.Forms.Label]$Label9 = $null
function InitializeComponent
{
$ButtonCreate = (New-Object -TypeName System.Windows.Forms.Button)
$ComboBoxDay = (New-Object -TypeName System.Windows.Forms.ComboBox)
$ComboBoxMMW = (New-Object -TypeName System.Windows.Forms.ComboBox)
$ComboBoxDL = (New-Object -TypeName System.Windows.Forms.ComboBox)
$Label1 = (New-Object -TypeName System.Windows.Forms.Label)
$Label2 = (New-Object -TypeName System.Windows.Forms.Label)
$Label3 = (New-Object -TypeName System.Windows.Forms.Label)
$Label4 = (New-Object -TypeName System.Windows.Forms.Label)
$Label5 = (New-Object -TypeName System.Windows.Forms.Label)
$TextBox3 = (New-Object -TypeName System.Windows.Forms.TextBox)
$TextBox4 = (New-Object -TypeName System.Windows.Forms.TextBox)
$Label6 = (New-Object -TypeName System.Windows.Forms.Label)
$Label7 = (New-Object -TypeName System.Windows.Forms.Label)
$ComboBoxMSUpdate = (New-Object -TypeName System.Windows.Forms.ComboBox)
$Label8 = (New-Object -TypeName System.Windows.Forms.Label)
$ClipCheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$XMLCheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$DateTimePickerStart = (New-Object -TypeName System.Windows.Forms.DateTimePicker)
$DateTimePickerEnd = (New-Object -TypeName System.Windows.Forms.DateTimePicker)
$ListBoxDay = (New-Object -TypeName System.Windows.Forms.ListBox)
$Label9 = (New-Object -TypeName System.Windows.Forms.Label)
$Form1.SuspendLayout()
#
#ButtonCreate
#
$ButtonCreate.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]612))
$ButtonCreate.Name = [System.String]'ButtonCreate'
$ButtonCreate.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]350,[System.Int32]65))
$ButtonCreate.TabIndex = [System.Int32]0
$ButtonCreate.Text = [System.String]'Create config'
$ButtonCreate.UseCompatibleTextRendering = $true
$ButtonCreate.UseVisualStyleBackColor = $true
$ButtonCreate.add_Click($Button1_Click)
#
#ComboBoxDay
#
$ComboBoxDay.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$ComboBoxDay.Enabled = $false
$ComboBoxDay.FormattingEnabled = $true
$ComboBoxDay.Items.AddRange([System.Object[]]@([System.String]'Daily',[System.String]'Selected Day(s)'))
$ComboBoxDay.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]241,[System.Int32]364))
$ComboBoxDay.Name = [System.String]'ComboBoxDay'
$ComboBoxDay.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]121,[System.Int32]21))
$ComboBoxDay.TabIndex = [System.Int32]1
$ComboBoxDay.add_SelectedIndexChanged($ComboBoxDay_SelectedIndexChanged)
#
#ComboBoxMMW
#
$ComboBoxMMW.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$ComboBoxMMW.FormattingEnabled = $true
$ComboBoxMMW.Items.AddRange([System.Object[]]@([System.String]'True',[System.String]'False'))
$ComboBoxMMW.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]241,[System.Int32]137))
$ComboBoxMMW.Name = [System.String]'ComboBoxMMW'
$ComboBoxMMW.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]121,[System.Int32]21))
$ComboBoxMMW.TabIndex = [System.Int32]6
$ComboBoxMMW.add_SelectedIndexChanged($ComboBoxMMW_SelectedIndexChanged)
#
#ComboBoxDL
#
$ComboBoxDL.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$ComboBoxDL.FormattingEnabled = $true
$ComboBoxDL.Items.AddRange([System.Object[]]@([System.String]'True',[System.String]'False'))
$ComboBoxDL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]241,[System.Int32]85))
$ComboBoxDL.Name = [System.String]'ComboBoxDL'
$ComboBoxDL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]121,[System.Int32]21))
$ComboBoxDL.TabIndex = [System.Int32]7
#
#Label1
#
$Label1.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]12,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]166,[System.Int32]442))
$Label1.Name = [System.String]'Label1'
$Label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]23))
$Label1.TabIndex = [System.Int32]8
$Label1.Text = [System.String]'Day(s)'
$Label1.UseCompatibleTextRendering = $true
#
#Label2
#
$Label2.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]12,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label2.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]148,[System.Int32]318))
$Label2.Name = [System.String]'Label2'
$Label2.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]74,[System.Int32]23))
$Label2.TabIndex = [System.Int32]9
$Label2.Text = [System.String]'End Time'
$Label2.UseCompatibleTextRendering = $true
#
#Label3
#
$Label3.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]12,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label3.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]138,[System.Int32]271))
$Label3.Name = [System.String]'Label3'
$Label3.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]84,[System.Int32]23))
$Label3.TabIndex = [System.Int32]10
$Label3.Text = [System.String]'Start Time'
$Label3.UseCompatibleTextRendering = $true
#
#Label4
#
$Label4.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]12,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label4.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]137))
$Label4.Name = [System.String]'Label4'
$Label4.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]223,[System.Int32]19))
$Label4.TabIndex = [System.Int32]11
$Label4.Text = [System.String]'Enable Maintenance Window'
$Label4.UseCompatibleTextRendering = $true
#
#Label5
#
$Label5.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]12,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label5.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]94,[System.Int32]85))
$Label5.Name = [System.String]'Label5'
$Label5.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]128,[System.Int32]23))
$Label5.TabIndex = [System.Int32]16
$Label5.Text = [System.String]'Direct Download'
$Label5.UseCompatibleTextRendering = $true
#
#TextBox3
#
$TextBox3.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]241,[System.Int32]184))
$TextBox3.Name = [System.String]'TextBox3'
$TextBox3.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]121,[System.Int32]21))
$TextBox3.TabIndex = [System.Int32]17
#
#TextBox4
#
$TextBox4.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]241,[System.Int32]231))
$TextBox4.Name = [System.String]'TextBox4'
$TextBox4.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]121,[System.Int32]21))
$TextBox4.TabIndex = [System.Int32]18
#
#Label6
#
$Label6.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]12,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label6.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]94,[System.Int32]184))
$Label6.Name = [System.String]'Label6'
$Label6.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]128,[System.Int32]23))
$Label6.TabIndex = [System.Int32]19
$Label6.Text = [System.String]'Hidden Updates'
$Label6.UseCompatibleTextRendering = $true
#
#Label7
#
$Label7.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]12,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label7.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]73,[System.Int32]231))
$Label7.Name = [System.String]'Label7'
$Label7.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]149,[System.Int32]23))
$Label7.TabIndex = [System.Int32]20
$Label7.Text = [System.String]'Un-Hidden Updates'
$Label7.UseCompatibleTextRendering = $true
$Label7.add_Click($Label7_Click)
#
#ComboBoxMSUpdate
#
$ComboBoxMSUpdate.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$ComboBoxMSUpdate.FormattingEnabled = $true
$ComboBoxMSUpdate.Items.AddRange([System.Object[]]@([System.String]'True',[System.String]'False'))
$ComboBoxMSUpdate.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]241,[System.Int32]37))
$ComboBoxMSUpdate.Name = [System.String]'ComboBoxMSUpdate'
$ComboBoxMSUpdate.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]120,[System.Int32]21))
$ComboBoxMSUpdate.TabIndex = [System.Int32]21
$ComboBoxMSUpdate.add_SelectedIndexChanged($ComboBoxMSUpdate_SelectedIndexChanged)
#
#Label8
#
$Label8.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]12,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label8.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]47,[System.Int32]37))
$Label8.Name = [System.String]'Label8'
$Label8.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]188,[System.Int32]23))
$Label8.TabIndex = [System.Int32]22
$Label8.Text = [System.String]'Force Microsoft Update'
$Label8.UseCompatibleTextRendering = $true
#
#ClipCheckBox
#
$ClipCheckBox.Checked = $true
$ClipCheckBox.CheckState = [System.Windows.Forms.CheckState]::Checked
$ClipCheckBox.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]12,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$ClipCheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]582))
$ClipCheckBox.Name = [System.String]'ClipCheckBox'
$ClipCheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]164,[System.Int32]24))
$ClipCheckBox.TabIndex = [System.Int32]23
$ClipCheckBox.Text = [System.String]'Copy to clipboard'
$ClipCheckBox.UseCompatibleTextRendering = $true
$ClipCheckBox.UseVisualStyleBackColor = $true
#
#XMLCheckBox
#
$XMLCheckBox.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]12,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$XMLCheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]223,[System.Int32]582))
$XMLCheckBox.Name = [System.String]'XMLCheckBox'
$XMLCheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]139,[System.Int32]24))
$XMLCheckBox.TabIndex = [System.Int32]24
$XMLCheckBox.Text = [System.String]'Create XML file'
$XMLCheckBox.UseCompatibleTextRendering = $true
$XMLCheckBox.UseVisualStyleBackColor = $true
$XMLCheckBox.add_CheckedChanged($XMLCheckBox_CheckedChanged)
#
#DateTimePickerStart
#
$DateTimePickerStart.CustomFormat = [System.String]'HH:mm'
$DateTimePickerStart.Enabled = $false
$DateTimePickerStart.Format = [System.Windows.Forms.DateTimePickerFormat]::Custom
$DateTimePickerStart.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]241,[System.Int32]273))
$DateTimePickerStart.Name = [System.String]'DateTimePickerStart'
$DateTimePickerStart.ShowUpDown = $true
$DateTimePickerStart.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]122,[System.Int32]21))
$DateTimePickerStart.TabIndex = [System.Int32]26
$DateTimePickerStart.Value = (New-Object -TypeName System.DateTime -ArgumentList @([System.Int32]2021,[System.Int32]5,[System.Int32]25,[System.Int32]0,[System.Int32]0,[System.Int32]0,[System.Int32]0))
#
#DateTimePickerEnd
#
$DateTimePickerEnd.CustomFormat = [System.String]'HH:mm'
$DateTimePickerEnd.Enabled = $false
$DateTimePickerEnd.Format = [System.Windows.Forms.DateTimePickerFormat]::Custom
$DateTimePickerEnd.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]241,[System.Int32]320))
$DateTimePickerEnd.Name = [System.String]'DateTimePickerEnd'
$DateTimePickerEnd.ShowUpDown = $true
$DateTimePickerEnd.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]121,[System.Int32]21))
$DateTimePickerEnd.TabIndex = [System.Int32]27
$DateTimePickerEnd.Value = (New-Object -TypeName System.DateTime -ArgumentList @([System.Int32]2021,[System.Int32]5,[System.Int32]25,[System.Int32]1,[System.Int32]0,[System.Int32]0,[System.Int32]0))
#
#ListBoxDay
#
$ListBoxDay.Enabled = $false
$ListBoxDay.FormattingEnabled = $true
$ListBoxDay.Items.AddRange([System.Object[]]@([System.String]'Monday',[System.String]'Tuesday',[System.String]'Wednesday',[System.String]'Thursday',[System.String]'Friday',[System.String]'Saturday',[System.String]'Sunday'))
$ListBoxDay.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]241,[System.Int32]408))
$ListBoxDay.Name = [System.String]'ListBoxDay'
$ListBoxDay.SelectionMode = [System.Windows.Forms.SelectionMode]::MultiSimple
$ListBoxDay.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]125,[System.Int32]95))
$ListBoxDay.TabIndex = [System.Int32]28
$ListBoxDay.add_SelectedIndexChanged($ListBox1_SelectedIndexChanged)
#
#Label9
#
$Label9.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]12))
$Label9.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]156,[System.Int32]362))
$Label9.Name = [System.String]'Label9'
$Label9.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]66,[System.Int32]23))
$Label9.TabIndex = [System.Int32]29
$Label9.Text = [System.String]'Interval'
$Label9.UseCompatibleTextRendering = $true
#
#Form1
#
$Form1.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]378,[System.Int32]689))
$Form1.Controls.Add($Label9)
$Form1.Controls.Add($ListBoxDay)
$Form1.Controls.Add($DateTimePickerEnd)
$Form1.Controls.Add($DateTimePickerStart)
$Form1.Controls.Add($XMLCheckBox)
$Form1.Controls.Add($ClipCheckBox)
$Form1.Controls.Add($Label8)
$Form1.Controls.Add($ComboBoxMSUpdate)
$Form1.Controls.Add($Label7)
$Form1.Controls.Add($Label6)
$Form1.Controls.Add($TextBox4)
$Form1.Controls.Add($TextBox3)
$Form1.Controls.Add($Label5)
$Form1.Controls.Add($Label4)
$Form1.Controls.Add($Label3)
$Form1.Controls.Add($Label2)
$Form1.Controls.Add($Label1)
$Form1.Controls.Add($ComboBoxDL)
$Form1.Controls.Add($ComboBoxMMW)
$Form1.Controls.Add($ComboBoxDay)
$Form1.Controls.Add($ButtonCreate)
$Form1.Text = [System.String]'Create Windows Update Policy'
$Form1.ResumeLayout($false)
$Form1.PerformLayout()
Add-Member -InputObject $Form1 -Name base -Value $base -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name ButtonCreate -Value $ButtonCreate -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name ComboBoxDay -Value $ComboBoxDay -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name ComboBoxMMW -Value $ComboBoxMMW -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name ComboBoxDL -Value $ComboBoxDL -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name Label1 -Value $Label1 -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name Label2 -Value $Label2 -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name Label3 -Value $Label3 -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name Label4 -Value $Label4 -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name Label5 -Value $Label5 -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name TextBox3 -Value $TextBox3 -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name TextBox4 -Value $TextBox4 -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name Label6 -Value $Label6 -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name Label7 -Value $Label7 -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name ComboBoxMSUpdate -Value $ComboBoxMSUpdate -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name Label8 -Value $Label8 -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name ClipCheckBox -Value $ClipCheckBox -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name XMLCheckBox -Value $XMLCheckBox -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name DateTimePickerStart -Value $DateTimePickerStart -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name DateTimePickerEnd -Value $DateTimePickerEnd -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name ListBoxDay -Value $ListBoxDay -MemberType NoteProperty
Add-Member -InputObject $Form1 -Name Label9 -Value $Label9 -MemberType NoteProperty
}
. InitializeComponent
