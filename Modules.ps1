cls

Get-Module -ListAvailable | Select Name, Version, ModuleType
#Import-Module -Name AppLocker
Import-Module .\Module.psm1 -Force
Add-Numbers 2 3
Substract-Numbers 2 3

New-ModuleManifest ./ModuleManifest.psd1