$Bitlocker = manage-bde -protectors -get c:
$BDEprotectors = $Bitlocker | Select-String -Pattern 'Numerical Password:' | select line,Linenumber

foreach($item in $BDEprotectors)
{
    $BDEID = $Bitlocker[$item.Linenumber].replace(' ','').replace('ID:','')
    manage-bde -protectors -adbackup c: -id $BDEID
}

