cls
Write-Host 'Script started.'

$SqlPackagePath = 'C:\Program Files (x86)\Microsoft SQL Server\120\DAC\bin\SqlPackage.exe'

Try
{
    &$SqlPackagePath /Action:Publish /SourceFile:"bin\Debug\Example.dacpac" /Profile:"Example.publish.xml" /TargetConnectionString:"Data Source=test;Initial Catalog=Example;Integrated Security=False;User ID=User;Password=..."
}
Catch
{
    Write-Error $_
    Break
}
Finally
{
    Write-Host 'Script stopped.'
}
    