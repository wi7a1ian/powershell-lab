cls

$EmailAddress = Read-Host -Prompt "Wpisz nazwê konta Microsoft..."
$Password = Read-Host -AsSecureString -Prompt "Wpisz has³o..."

#http://msdn.microsoft.com/en-us/library/ms970456.aspx
$ie = New-Object -ComObject InternetExplorer.Application
$ie.navigate("about:blank")
$ie.height = 800
$ie.width = 1200
$ie.visible = $true

#Wait for the page to load...
while($ie.Busy){Start-Sleep -Milliseconds 500}

#$doc = $ie.document
#$tbUsername = $doc.getElementByID("i0116")
#$tbUsername.value = $EmailAddress
#$tbPassword = $doc.getElementByID("i0118")
#$tbPassword = $Password
#$btnSubmit = $doc.getElementByID("idSIButton9")
#$btnSubmit.Click();
