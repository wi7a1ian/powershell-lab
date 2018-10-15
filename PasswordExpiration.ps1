cls
net user ([Environment]::UserName) /domain | select-string '\bPassword Expires*\b'
