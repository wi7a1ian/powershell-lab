cls

Try
{
    Get-ChildItem C:\Temp
}
Catch [System.Exception]
{
    "Nie znaleziono"
    New-Item -ItemType Directory -Path C:\Temp
    $Error[0].Exception
    $LASTEXITCODE
}
Finally
{
    "Już jest"
}
