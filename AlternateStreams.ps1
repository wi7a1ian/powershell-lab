cls #DA39A3EE5E6B4B0D3255BFEF95601890AFD80709
$FilePath = '\\M-ZAGDAN1V\testcontaineroutput\WRIGHT_Matter(1).zip`[1`]\BANNON\Bannon US Forensic 6.06.397\thumbs.db'
$FilePath = '\\M-ZAGDAN1V\testcontaineroutput\WRIGHT_Matter(1).zip`[1`]\Pumilia v. Fidelity\thumbs.db'
#$FilePath = 'C:\Users\WZajac\Desktop\SomeFile.txt'

Get-Item $FilePath -Stream *

# SHA1 from KO alternate stream
#[xml]$KOStream = (Get-Content $FilePath -Stream !KOEnhancedMetadata)
#$KOStream.SelectNodes("//Hash/@HashType") | % { $_.FirstChild.Value } | select –Unique
#$KOStream.SelectNodes("/root/Hash") | % { $_.InnerText } | select –Unique
Get-Content $FilePath -Stream !KOEnhancedMetadata | Select-Xml "/root/Hash" | % { $_.Node.InnerText } | select -Unique

# SHA1 from primary stream 
Get-FileHash $FilePath -Algorithm SHA1 | % {$_.Hash}

#Clear-Content $FilePath -Stream !KOEnhancedMetadata
#Remove-Item $FilePath -Stream !KOEnhancedMetadata
#Add-Content $FilePath -Stream !KOEnhancedMetadata "[ZoneTransfer]`r`nZoneId=3"