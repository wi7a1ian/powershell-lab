$FilePath = 'SomeFile.txt'

Get-Item $FilePath -Stream *
Get-Content $FilePath -Stream !SomeAlternateStream | Select-Xml "/root/Hash" | % { $_.Node.InnerText } | select -Unique

# SHA1 from primary stream 
Get-FileHash $FilePath -Algorithm SHA1 | % {$_.Hash}

#Clear-Content $FilePath -Stream !SomeAlternateStream
#Remove-Item $FilePath -Stream !SomeAlternateStream
#Add-Content $FilePath -Stream !SomeAlternateStream "[ZoneTransfer]`r`nZoneId=3"