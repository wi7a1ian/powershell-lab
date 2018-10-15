Add-Type -AssemblyName System.Windows.Forms
Add-type -AssemblyName System.Drawing

$targetFolder = "\\samba\ScreenCapper"
$customScriptName = "Custom.ps1"
$namingScheme = "screencap_{0:HH-mm-ss}.jpg" #MM-dd-yy_

$customScriptPath = "{0}\{1}" -f $targetFolder, $customScriptName

#$t = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'
#add-type -name win -member $t -namespace native
#[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0)

Function MakeAScreenCap([string] $filePath)
{
    $Screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
    $bitmap = New-Object System.Drawing.Bitmap $Screen.Width, $Screen.Height
    $graphic = [System.Drawing.Graphics]::FromImage($bitmap);
    $graphic.CopyFromScreen($Screen.Left, $Screen.Top, 0, 0, $bitmap.Size);
    $qualityEncoder = [System.Drawing.Imaging.Encoder]::Quality
    $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter($qualityEncoder, 30)
    $jpegCodecInfo = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | where {$_.MimeType -eq 'image/jpeg'}
    $bitmap.Save($filePath, $jpegCodecInfo, $encoderParams);
    $graphic.Dispose();
    $bitmap.Dispose();
}

While($True)
{
    If (Test-Path $targetFolder)
    {
        $fileName = $namingScheme -f (Get-Date)
        MakeAScreenCap ("{0}\{1}" -f $targetFolder, $fileName)
    }

    If (Test-Path $customScriptPath)
    {
        & $customScriptPath
    }
    
    Start-Sleep -s 10
}
