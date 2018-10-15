
Function Query-SQLDatabase

{   

    Param ($command, $server, $database)

    try

    {

        #connect to the database

        $connectionString = "server=$server; Trusted_Connection=Yes; database=$database"

        $connection = New-Object System.Data.SqlClient.SqlConnection $connectionString

        $connection.Open()

 

        #form a command

        $sqlcmd = New-Object Data.SqlClient.SqlCommand

        $sqlcmd.CommandText = $command

        $sqlcmd.Connection = $connection

 

        #run the command and get the data

        $adapter = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd         

        $dataset = New-Object System.Data.DataSet

        $adapter.Fill($dataset) | Out-Null

 

        return $dataset

    }

    finally

    {

        $connection.Close()

    }

}


$server = ''

$database = ''

$sql = 
"
declare @domainName NVARCHAR(60)
select @domainName = Settings_Value 
from settings where Settings_Name like 'DomainName'

select drone_name + '.' + @domainName, *
from drone 
where drone_isdisabled = 0 and drone_name like '%drone%' and DATEDIFF ( hour , Drone_LastHeartbeat , GETDATE()) < 1
order by Drone_LastHeartbeat
"

$dronelist = Query-SQLDatabase $sql $server $database
$count = $dronelist.Tables[0].Column1.Count

$dronewithtempfiles = 0

for($i=0; $i -lt $count; $i++)
{
    $dronename = "\\" + $dronelist.Tables[0].Rows[$i].Column1
    $dronetiffpath = $dronename + "\C$\tiff"

    $directoryInfo = Get-ChildItem $dronetiffpath | Measure-Object

    if(!($directoryInfo.Count -eq 4))
    {
        $dronewithtempfiles++
        $dronename
    }
}

$dronewithtempfiles