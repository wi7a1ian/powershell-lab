Workflow Send-Greetings
{
    [CmdletBinding()]
    param([string] $Name)
    "Witaj, $Name"
}

Workflow Get-Information
{
    Get-Service
    Get-Process
    Get-CimClass -ClassName Win32_BIOS
}

Workflow Get-InformationSequence
{
    Sequence
    {
        Get-Service
        Get-Process
        Get-CimClass -ClassName Win32_BIOS
    }
}

Workflow Get-InformationParallel
{
    Parallel
    {
        Get-Service
        Get-Process
        Get-CimClass -ClassName Win32_BIOS
    }
}

Workflow Test-ParallelLoop
{
    $chromeProcs = Get-Process | Where {$_.ProcessName -like "chro*"} |  select ID, ProcessName, CPU

    ForEach -Parallel ($chromProc in $chromeProcs)
    {
        Write-Output "Proc $($chromProc.ProcessName) uses $($chromProc.CPU)% of CPU"
    }
}

#InlineScript { }
#Suspend-Workflow
#Resume-Job -Name Job31
#Get-Job Job34 | Receive-Job
#Restart-Computer -Wait -PSConnectionRetryInterval 4 -PSConnectionRetryCount 8
