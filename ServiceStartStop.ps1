$service = Get-Service "Storage Manager Remote Object Service*"
if ($service)
{
    if ($service.status -ne "Running")
    {
        $waitInterval = new-timespan -seconds 600
        $service | Start-Service
        #$service | Stop-Service
        $service.WaitForStatus("Running", $waitInterval)
    }
    exit 0
}
else
{
    Write-Error "No service found."
    exit 1
}