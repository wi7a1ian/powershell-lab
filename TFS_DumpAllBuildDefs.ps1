cls

[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Client")
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.Build.Client")

$TeamProjects =  @( "...")
$DirectoryToDump = "C:\BuildDefinition"

             
$TFS_Server = "http://localtfs:8080/tfs/..."
if (Test-Path $DirectoryToDump)
{
    Remove-Item $DirectoryToDump -Recurse;
}
New-Item $DirectoryToDump -type directory
       
$TFS = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($TFS_Server)
$BuildServer =  $TFS.GetService([Microsoft.TeamFoundation.Build.Client.IBuildServer])
forEach ($TeamProject in $TeamProjects)
{
    $BuildDefinions = $BuildServer.QueryBuildDefinitions($TeamProject)
    foreach ($BuildDefinion in $BuildDefinions)
    {
       $FileName = $DirectoryToDump + $BuildDefinion.Name  
       Set-Content -Path $FileName -Value $BuildDefinion.ToString()
    }
} 
