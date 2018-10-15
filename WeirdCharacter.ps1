Remove-Variable * -ErrorAction SilentlyContinue
Clear-Host

<#
select 
	OriginalFileName, 
	SUBSTRING(OriginalFileName, 12, 1) AS CharToRemove1, 
	SUBSTRING(OriginalFileName, 13, 1) AS CharToRemove1,
	CONVERT(VARBINARY(MAX), SUBSTRING(OriginalFileName, 12, 1)) AS CharToRemove1Hex,
	CONVERT(VARBINARY(MAX), SUBSTRING(OriginalFileName, 13, 1)) AS CharToRemove2Hex,
	CONVERT(VARBINARY(MAX), OriginalFileName),
	* 
FROM [File]
WHERE FileID = 19823
# 0xBF057A0320002000A507650320002102E405B2042000C2D77BDC20002000200020002E00700070007400
# 0xBF05 7A03 2000 2000 A507 6503 2000 2102 E405 B204 2000 C2D7 7BDC 2000 2000 2000 2000 2E00 7000 7000 7400
# It is in little-endian (reverted bytes) so we need to convert to big-endian 
#>

[char[]]$FileNameAsArray = @(0x05BF, 0x037A, 0x0020, 0x0020, 0x07A5, 0x0365, 0x0020, 0x0221, 0x05E4, 0x04B2, 0x0020, <# HERE #> 0xD7C2, 0xDC7B, <# END #> 0x0020, 0x0020, 0x0020, 0x0020, 0x002E, 0x0070, 0x0070, 0x0074)
$FileName = $FileNameAsArray -join ''# | out-string # <-- this shit was adding two additional \0 at the end causing all the IO methods to fail!!
$FilePath = [string]::Format("C:\{0}", $FileName)
$TmpPath = "C:\test.txt"
$TestPath = "C:\"

Add-Type -TypeDefinition @"
namespace Win32 {
	[System.Flags]
    public enum MoveFileFlags : int
    {
        MOVEFILE_REPLACE_EXISTING           = 0x00000001,
        MOVEFILE_COPY_ALLOWED               = 0x00000002,
        MOVEFILE_DELAY_UNTIL_REBOOT         = 0x00000004,
        MOVEFILE_WRITE_THROUGH              = 0x00000008,
        MOVEFILE_CREATE_HARDLINK            = 0x00000010,
        MOVEFILE_FAIL_IF_NOT_TRACKABLE      = 0x00000020
    }
}
"@;

$MethodDefinition = @'
[DllImport("kernel32.dll", CharSet = CharSet.Unicode)]
public static extern bool CopyFile(string lpExistingFileName, string lpNewFileName, bool bFailIfExists);

[DllImport("kernel32.DLL", EntryPoint = "MoveFileW", SetLastError = true, CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
public static extern bool MoveFile(string lpExistingFileName, string lpNewFileName);


[DllImport("kernel32.DLL", EntryPoint = "MoveFileExW", SetLastError = true, CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
public static extern bool MoveFileEx(string lpExistingFileName, string lpNewFileName, int flags);
'@
$Kernel32 = Add-Type -MemberDefinition $MethodDefinition -Name 'Kernel32' -Namespace 'Win32' -Using Win32 -PassThru


If (Test-Path $TmpPath)
{
	Remove-Item $TmpPath
}

If (Test-Path $FilePath)
{
	Remove-Item $FilePath
}

Write-Output "# 1 Create"
New-Item $FilePath -ItemType file -Force -Value 'Test' | out-null #>$null 2>&1

Write-Output "# 2 .NET Create"
[IO.File]::WriteAllText($FilePath, "Test", [Text.Encoding]::Unicode)  | out-null

New-Item $TmpPath -ItemType file -Force -Value 'Test' | out-null
Remove-Item $FilePath | out-null
Write-Output "# 3 Create temp and then rename"
Rename-Item $TmpPath $FilePath | out-null # Fail

New-Item $TmpPath -ItemType file -Force -Value 'Test' | out-null
Remove-Item $FilePath | out-null
Write-Output "# 4 .NET move"
[IO.File]::Move($TmpPath, $FilePath)  | out-null

New-Item $TmpPath -ItemType file -Force -Value 'Test' | out-null
Write-Output "# 5 Kernel32 copy"
$Kernel32::CopyFile($TmpPath, $FilePath, $False) | out-null

New-Item $TmpPath -ItemType file -Force -Value 'Test' | out-null
Write-Output "# 6 Kernel32 move"
$Kernel32::MoveFile($TmpPath, $FilePath) | out-null

New-Item $TmpPath -ItemType file -Force -Value 'Test' | out-null
Write-Output "# 7 Kernel32 ex MOVEFILE_COPY_ALLOWED"
$Kernel32::MoveFileEx($TmpPath, $FilePath, [Win32.MoveFileFlags]::MOVEFILE_COPY_ALLOWED) | out-null

New-Item $TmpPath -ItemType file -Force -Value 'Test' | out-null
Write-Output "# 8 Kernel32 ex MOVEFILE_REPLACE_EXISTING"
$Kernel32::MoveFileEx($TmpPath, $FilePath, $Kernel32::MoveFileFlags.MOVEFILE_REPLACE_EXISTING) | out-null

# Test ------------------------------------------------------------------------------------------

if ([IO.File]::Exists($FilePath)){
    Write-Output "File got created!"
}

$ActualFileName = Get-ChildItem $TestPath  -filter *.ppt | Select-Object -First 1 | % { $_.Name }
if ($ActualFileName -ne $FileName){
    ([System.Text.Encoding]::Unicode.GetBytes($ActualFileName) | foreach { " 0x"+$_.ToString("X2") }) -join ""
    ([System.Text.Encoding]::Unicode.GetBytes($FileName) | foreach { " 0x"+$_.ToString("X2") }) -join ""
}


<#
# Open zip and find the particular file (assumes only one inside the Zip file)
Add-Type -assembly  System.IO.Compression.FileSystem
$ZipFilePath = "C:\weird.zip"

If (Test-Path $ZipFilePath)
{
	Remove-Item $ZipFilePath
}

$zip =  [System.IO.Compression.ZipFile]::Open($ZipFilePath, [System.IO.Compression.ZipArchiveMode]::Create)#, [Text.Encoding]::Unicode)
#$robotsFile = $zip.Entries.Where({$_.name -eq $fileToEdit})

# Create file entry
[System.IO.Compression.ZipArchiveEntry] $TargetFile = $zip.CreateEntry($FileName);

# Update the contents of the file
#$desiredFile = [System.IO.StreamWriter]($robotsFile).Open()
#$desiredFile.BaseStream.SetLength(0)
#$desiredFile.Write($contents)
#$desiredFile.Flush()
#$desiredFile.Close()

$zip.Contains($FileName)

# Write the changes and close the zip file
$zip.Dispose()
#>

