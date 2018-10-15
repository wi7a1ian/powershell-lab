Remove-Variable * -ErrorAction SilentlyContinue
Clear-Host

$artifactoryPath = 'http://artifactory'
$apiKey = ''
$apiKeyBase64 = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($apiKey))

$simulate = 1 # 1 = show only what "would" have get deleted

$remPackLike = '*.0.3.3.*.nupkg' # filter package name
$remFromPath = @(
    'nuget-apps-snapshot-local:Output.Actions',
);
$remOlderThan = New-Timespan -Days 30; # 0 to remove all

ForEach( $repoFolder in $remFromPath)
{
    $repoFolderPair = $repoFolder.Split(":")

    $folderPath = "{0}/api/storage/{1}/{2}" -f $artifactoryPath, $repoFolderPair[0], $repoFolderPair[1];

    $packages = Invoke-RestMethod -Method Get -Uri $folderPath -Header @{ "Authorization" = "Basic " + $apiKeyBase64 } | Select-Object children

    ForEach($package in ( $packages.children | Where-Object { $_.uri -like $remPackLike -and -not $_.folder}))
    {
        $packageUri = "{0}/api/storage/{1}/{2}" -f $artifactoryPath, $repoFolderPair[0], $repoFolderPair[1] + $package.uri;
        $packInfo = Invoke-RestMethod -Method Get -Uri $packageUri -Header @{ "Authorization" = "Basic " + $apiKeyBase64 };
        $packCreateDate = [DateTime]::Parse($packInfo.created);

        If(((get-date) - $packCreateDate) -gt $remOlderThan)
        {
            $packageUri = "{0}/{1}/{2}" -f $artifactoryPath, $repoFolderPair[0], $repoFolderPair[1] + $package.uri;
            "Deleting " + $packageUri + " from " + $packCreateDate

            If( -not $simulate )
            {
                Invoke-RestMethod -Method Delete -Uri $packageUri -Header @{ "Authorization" = "Basic " + $apiKeyBase64 };
            }
        }
    }
}
