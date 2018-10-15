# Windows Server only
Get-WindowsFeature | Where Installed -eq $True
Install-WindowsFeature Web-Server -IncludeAllSubFeature -IncludeManagementTools

# Create new local acc
$Server = [ADSI]"WinNT://SomeServer"
$User = $Server.Create("User", "Testuser")
$User.SetPassword("P@ssw0rd")
$User.CommitChanges()

$Server.Children | Where {$._Class -eq "User" -or $_.Class -eq "Group"} | Select Name, SchemaClassName
