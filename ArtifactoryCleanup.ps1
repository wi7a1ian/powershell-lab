<#
There are a couple of ways to run this
1. load it up in ISE and edit the values and run it
2. Edit it and run it from powershell (e.g., .\ArtifactoryCleanup.ps1)
3. Leave it as is and pass parameters to it (e.g., .\ArtifactoryCleanup.ps1 -versionFilter "0.2.1.*" -ageFilter 90 -simulate 0) from powershell prompt
#>
param(
    # package versions to find
    $versionFilter = $(throw "Provide versionFilter. ex: -versionFilter 0.3.0.*"),
    # remove packages older than x days
    $ageFilter = $(throw "Provide age filter. ex: -ageFilter 0. 0 = to remove all packages.  Otherwise only remove packages older than days provided."),
    #server job is on
	#$server = $(throw "Provide server name. ex: -server MSPT1PCCDBJ001.cct.edt.local\CC1J001"),
    $simulate = $(throw "Provide simulate parameter. ex: -simulate 1 = show only what would have got deleted")
)

#Remove-Variable * -ErrorAction SilentlyContinue
Clear-Host
$artifactoryPath = 'http://artifactory'

if( $simulate -eq 0 )
{
    $creds = Get-Credential -Message "Enter credentials for Artifactory, no domain prefix required."
    if(!$creds){exit}
    $apiKey = $creds.UserName + ":" + $creds.GetNetworkCredential().Password
    $apiKeyBase64 = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($apiKey))
    Clear-Variable apiKey -ErrorAction Stop # clear this out.
    Clear-Variable creds -ErrorAction Stop
}

$remPackLike = "*.$($versionFilter).nupkg" # filter package name
$remFromPath = @(
    'nuget-apps-snapshot-local:Some.Package',
    'nuget-apps-snapshot-local:Some.OtherPackage'
);

$remOlderThan = New-Timespan -days $ageFilter # 0 to remove all

ForEach( $repoFolder in $remFromPath)
{
    $repoFolderPair = $repoFolder.Split(":");

    $folderPath = "{0}/api/storage/{1}/{2}" -f $artifactoryPath, $repoFolderPair[0], $repoFolderPair[1];
    
    $packages = Invoke-RestMethod -Method Get -Uri $folderPath | Select-Object children;

    ForEach($package in ( $packages.children | Where-Object { $_.uri -like $remPackLike -and -not $_.folder}))
    {
        $packageUri = "{0}/api/storage/{1}/{2}" -f $artifactoryPath, $repoFolderPair[0], $repoFolderPair[1] + $package.uri;
        $packInfo = Invoke-RestMethod -Method Get -Uri $packageUri;
        $packCreateDate = [DateTime]::Parse($packInfo.created);

        If(((get-date) - $packCreateDate) -gt $remOlderThan)
        {
            $packageUri = "{0}/{1}/{2}" -f $artifactoryPath, $repoFolderPair[0], $repoFolderPair[1] + $package.uri;
            
            If( $simulate -eq 0 )
            {
                Write-Output ("Deleting $($packageUri) Date - $($packCreateDate)");
                Invoke-RestMethod -Method Delete -Uri $packageUri -Header @{ "Authorization" = "Basic " + $apiKeyBase64 };
            }
            else
            {                
                Write-Output ('SimulateDelete ' + $package.uri.ToString() + ' Date - ' + $packCreateDate.ToString());
            }
        }
    }
}
# clear variables when we are done.
Clear-Variable remFromPath -ErrorAction SilentlyContinue
Clear-Variable packages -ErrorAction SilentlyContinue
Clear-Variable apiKeyBase64 -ErrorAction SilentlyContinue