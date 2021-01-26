# This small script will encode the .ps1 file to base 64
# After the encoding you can deploy the script via CSP


# change input and output file as needed

$Script = Get-content -Path C:\Temp\Test.ps1 -Raw
$bytes = [System.Text.Encoding]::Unicode.GetBytes($Script)
[Convert]::ToBase64String($bytes) | out-file C:\Temp\test.txt
