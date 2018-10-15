#http://www.lazywinadmin.com/2014/03/powershell-read-excel-file-using-com.html

cls
$Excel = New-Object -Com Excel.Application
#$Excel | Get-Member
#$Excel.WorkBooks | Select-Object -Property name, path, author
#$Excel.WorkBooks | Get-Member
$Excel.visible = $true
$ExcelWB = $Excel.Workbooks.Add()
$ExcelWS = $ExcelWB.Worksheets.Item(1)
$ExcelWS.Cells.Item(1,1) = "Raport o stanie us³ug"
$ExcelWS.Range("A1","B1").Cells.Merge()
$ExcelWS.Cells.Item(2,1) = "Nazwa"
$ExcelWS.Cells.Item(2,2) = "Stan"
$ExcelWS.Cells.Item(2,2).Font.ColorIndex = 3
$ExcelWS.SaveAs("c:\Laboratory\PowerShell\Data.xlsx")
$Excel.Quit()
#Stop-Process -Name EXCEL -Force
exit;

<#
[pscustomobject][ordered]@{
	ComputerName = $WorkSheet.Range("C3").Text
	Project = $WorkSheet.Range("C4").Text
	Ticket = $WorkSheet.Range("C5").Text
	Role = $WorkSheet.Range("C8").Text
	RoleType = $WorkSheet.Range("C9").Text
	Environment = $WorkSheet.Range("C10").Text
	Manufacturer = $WorkSheet.Range("C12").Text
	SiteCode = $WorkSheet.Range("C15").Text
	isDMZ = $WorkSheet.Range("C16").Text
	OperatingSystem = $WorkSheet.Range("C18").Text
	ServicePack = $WorkSheet.Range("C19").Text
	OSKey = $WorkSheet.Range("C20").Text
	Owner = $WorkSheet.Range("C22").Text
	MaintenanceWindow = $WorkSheet.Range("C23").Text
	NbOfProcessor = $WorkSheet.Range("C26").Text
	NbOfCores = $WorkSheet.Range("C27").Text
	MemoryGB = $WorkSheet.Range("C29").Text
}
#>