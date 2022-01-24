$PendingReboot = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status -Name "PendingReboot"
if($PendingReboot.PendingReboot -eq "True")
{
Return $True
}
else{return $False}