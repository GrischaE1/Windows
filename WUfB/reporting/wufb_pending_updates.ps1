$PendingUpdates = Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Custom\WindowsUpdate\Status -Name "Open Pending Updates"
if($PendingUpdates.'Open Pending Updates' -eq "True")
{
Return $True
}
else{return $False}