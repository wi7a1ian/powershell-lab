cls

$xmlData = [xml](Get-Content C:\Laboratory\PowerShell\Data.xml)
[xml] $xmlData = Get-Content C:\Laboratory\PowerShell\Data.xml
#$xmlData
$xmlData.staff.ChildNodes
$xmlData.staff.branch.Attributes
$xmlData.staff.branch.location
$xmlData.staff.branch[0].location = 'Katowice'
$xmlData.staff.branch
cls

$xmlData.SelectNodes("//employee[Name='Sherif Talaat']") | ft
cls

$newEml = $xmlData.CreateElement("employee")
$newEml.InnerXml = "<Name>Witek</Name><Role>Geniusz Z³a</Role>"
$xmlData.staff.branch[0].AppendChild($newEml);
$xmlData.staff.branch[0].employee | ft
cls

#Select-XML
Select-Xml -Path C:\Laboratory\PowerShell\Data.xml -XPath "/staff/branch/employee" |FT