cls

#http://www.howtogeek.com/117192/how-to-run-powershell-commands-on-remote-computers/
#http://blogs.msdn.com/b/powershell/archive/2009/04/30/enable-psremoting.aspx

# On both machines:

# Enable remote access and configure WinRM
#Enable-PSRemoting -Force #-SkipNetworkProfileCheck
#winrm quickconfig
##winrm set winrm/config/client '@{TrustedHosts="MALINOWSKA"}'

# Set trusted hosts on both client and server
#Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value "MALINOWSKA"
#Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value "Wit-Komputer"
# Validate
#Get-Item WSMan:\localhost\Client\TrustedHosts

#Restart-Service WinRM

# Testing the connection
Test-WsMan MALINOWSKA #-UseSSL
Test-WsMan Wit-Komputer #-UseSSL
# should display anything or error if failed to connect to remote WinRM

#. .\Take-ScreenShot.ps1
#. "$PSScriptRoot\Take-ScreenShot.ps1"
#Import-Module "$PSScriptRoot\Take-ScreenShot.psm1" -Force
#Take-ScreenShot -screen -file "C:\image.png" -imagetype png

$credential = Get-Credential -Credential malinowska\wit
#Invoke-Command -ComputerName MALINOWSKA -ScriptBlock { Get-ChildItem C:\ } -Credential $credential
#Invoke-Command -ComputerName MALINOWSKA -ScriptBlock { Take-ScreenShot -screen -file "C:\image.png" -imagetype png } -Credential $credential
#Enter-PSSession -ComputerName MALINOWSKA -Credential Wit-Komputer\Wit

$s = New-PSSession -ComputerName MALINOWSKA -Credential $credential

Test-Path \\WIT-KOMPUTER\Shared\Take-ScreenShot.psm1
Invoke-Command -Session $s -ScriptBlock { Test-Path \\WIT-KOMPUTER\Shared\Take-ScreenShot.psm1 }
# TODO: double hop issue http://blogs.msdn.com/b/clustering/archive/2009/06/25/9803001.aspx
#Invoke-Command -Session $s -ScriptBlock { Import-Module "\\WIT-KOMPUTER\Shared\Take-ScreenShot.psm1" -Force }
#Invoke-Command -Session $s -ScriptBlock { Take-ScreenShot -screen -file "\\WIT-KOMPUTER\Shared\screencap.png" -imagetype png }
Remove-PSSession -session $s