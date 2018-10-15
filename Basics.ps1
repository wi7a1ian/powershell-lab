Set-ExecutionPolicy RemoteSigned
$PSVersionTable.PSVersion
(Get-Date).DateTime
Get-Process | Get-Member | Format-Table
Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 5 -Property ProcessName,CPU,VirtualMemorySize | Format-Table
Get-Process | Where {$_.ProcessName -like "chro*"} |  select ID, ProcessName, CPU
Get-Process | Where {$_.ProcessName -like "chro*"} |  % { $_.ID, $_.ProcessName, $_.CPU }
Get-Process | Where {$_.ProcessName -like "chro*"} |  select { $_.ID, $_.ProcessName, $_.CPU } |FT
gps | Sort -Property CPU -Des | Select -First 5 -Property ProcessName,CPU,VirtualMemorySize | FT
Get-Alias
$a = 1; $b = "2.5"; $c = 3.5; $a + $b + $c;
Get-Variable | FT
$Variable:Host
$arr = @(); $arr = 1,2,3,4,'a',"b",(Get-Service); $arr;
$hashtable = @{1 = 'red'; blue='blue'}; $hashtable | ft;

#-ne -eq -gt -le -ge -contains -notcontains -like -notlike -match -replace -and -or -not

If ( $args[0] -eq '' ){}
ElseIf( $args[1] -eq ''){}
Else{}

Function Avg([Int] $n1, [Int] $n2, [Int] $n3){
    return ($n1+$n2+$n3)/3;
}
Avg 1 2 3;
Avg -n1 1 -n2 2 -n3 3;

Get-PSProvider
Set-Location Cert:/; Get-ChildItem|ft;
Set-Location C:/; Get-ChildItem|ft;

<# Execute script:
.\Laboratory\PowerShell\Basics.ps1   # .\ is important
#>

Get-Help Get-Process -Examples

5,10,30,50 | % {

    $url= https://gdata.youtube.com/feeds/api/videos?v=2&q=Powershell&max-results=$_;

    (Invoke-RestMethod $url).count

}
