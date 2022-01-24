$InstalledKBs = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status -Name "Installed KBs"
if($InstalledKBs)
{
Return "$($InstalledKBs.'Installed KBs')"
}
else{return "No Update installed"}