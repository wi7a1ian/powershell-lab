cls
Write-Host 'Script started.'

Try
{
    #Register the DLL we need
    Add-Type -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\110\DAC\bin\Microsoft.SqlServer.Dac.dll" 

    #Read a publish profile XML to get the deployment options
    $dacProfile = [Microsoft.SqlServer.Dac.DacProfile]::Load("Example.publish.xml")
    $dacProfile.DeployOptions.BackupDatabaseBeforeChanges = $true
    $dacProfile.TargetConnectionString += ";Password=..."
    $dacProfile.TargetConnectionString = "Data Source=Example;Initial Catalog=Example;Integrated Security=False;User ID=User;Password=..."

    #Use the connect string from the profile to initiate the service
    $dacService = New-Object Microsoft.SqlServer.dac.dacservices ($dacProfile.TargetConnectionString)
    Register-ObjectEvent -in $dacService -eventname Message -source "msg" -action { Out-Host -in $Event.SourceArgs[1].Message.Message } | Out-Null

    #Load the dacpac
    $dacPackage = [Microsoft.SqlServer.Dac.DacPackage]::Load("bin\Debug\Example.dacpac")

    #Publish or generate the script (uncomment the one you want)
    $dacService.deploy($dacPackage, $dacProfile.TargetDatabaseName, $true, $dacProfile.DeployOptions)
    #$dacService.GenerateDeployScript($dacPackage, $dacProfile.TargetDatabaseName, $dacProfile.DeployOptions)
}
Catch
{
    Write-Error $_
    Break
}
Finally
{
    Unregister-Event -source "msg" 
    Write-Host 'Script stopped.'
}
    