cls

param (
	[Parameter(Mandatory=$true)]
	[string]$connectionString
)
$ErrorActionPreference = "Stop"

Write-Host -NoNewline -ForegroundColor Gray "Trying to open connection to the database... " 

$connection = New-Object -TypeName System.Data.SqlClient.SqlConnection -ArgumentList $connectionString
$connection.Open();

Write-Host -ForegroundColor Green "Success!"
Write-Host -NoNewline -ForegroundColor Gray "Trying to query list of schemas... "

$command = $connection.CreateCommand();
$command.CommandText="IF EXISTS (SELECT 1 FROM sys.schemas) SELECT 1 ELSE SELECT 0"
$result = $command.ExecuteScalar()

if($result -eq "0")
{
	throw "Can't read from database."
}

Write-Host -ForegroundColor Green "Success!"
Write-Host -NoNewline -ForegroundColor Gray "Trying to start a database transction... "

$transaction = $connection.BeginTransaction();
$command.Transaction = $transaction;

Write-Host -ForegroundColor Green "Success!"
Write-Host -NoNewline -ForegroundColor Gray "Trying to create a table... "

$command.CommandText="CREATE TABLE Dummy(id int identity(1,1))"
$result = $command.ExecuteNonQuery();

Write-Host -ForegroundColor Green "Success!"
Write-Host -NoNewline -ForegroundColor Gray "Rolling back transaction (effectively removing the table)... "

$transaction.Rollback();

Write-Host -ForegroundColor Green "Success!"
Write-Host
Write-Host "You have sufficient rights to create a table in the target database. This"
Write-Host "typically means that you are a member of the dbo role."