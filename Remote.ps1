cls

#http://www.howtogeek.com/117192/how-to-run-powershell-commands-on-remote-computers/
#http://blogs.msdn.com/b/powershell/archive/2009/04/30/enable-psremoting.aspx

# On both machines:

# Enable remote access and configure WinRM
#Enable-PSRemoting -Force #-SkipNetworkProfileCheck
#winrm quickconfig
##winrm set winrm/config/client '@{TrustedHosts="Machine1"}'

# Set trusted hosts on both client and server
#Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value "Machine1"
#Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value "Machine2"
# Validate
#Get-Item WSMan:\localhost\Client\TrustedHosts

#Restart-Service WinRM

# Testing the connection
Test-WsMan Machine1 #-UseSSL
Test-WsMan Machine2 #-UseSSL
# should display anything or error if failed to connect to remote WinRM

$credential = Get-Credential -Credential Machine1\SomeUsername
#Invoke-Command -ComputerName Machine1 -ScriptBlock { Get-ChildItem C:\ } -Credential $credential
#Invoke-Command -ComputerName Machine1 -ScriptBlock { Take-ScreenShot -screen -file "C:\image.png" -imagetype png } -Credential $credential
#Enter-PSSession -ComputerName Machine1 -Credential Machine2\SomeUsername

$s = New-PSSession -ComputerName Machine1 -Credential $credential

Test-Path \\Machine2\Shared\Take-ScreenShot.psm1
Invoke-Command -Session $s -ScriptBlock { Test-Path \\Machine2\Shared\Take-ScreenShot.psm1 }
# TODO: double hop issue http://blogs.msdn.com/b/clustering/archive/2009/06/25/9803001.aspx
#Invoke-Command -Session $s -ScriptBlock { Import-Module "\\Machine2\Shared\Take-ScreenShot.psm1" -Force }
#Invoke-Command -Session $s -ScriptBlock { Take-ScreenShot -screen -file "\\Machine2\Shared\screencap.png" -imagetype png }
Remove-PSSession -session $s