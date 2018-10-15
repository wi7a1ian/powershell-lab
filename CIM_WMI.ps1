Get-Command *WMI* -Type Cmdlet
Get-Command *CIM* -Type Cmdlet

Get-CimInstance -ClassName Win32_BIOS

$Query = "Select * From Win32_NetworkAdapter Where Name Like '%Intel%'"
Get-WmiObject -Query $Query |Select DeviceID, Name
Get-CimInstance -Query $Query |Select DeviceID, Name