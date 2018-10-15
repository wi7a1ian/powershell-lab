cls
# https://www.visualstudio.com/integrate/api/work/boards
# https://www.visualstudio.com/integrate/api/work/rows
# https://www.visualstudio.com/en-us/integrate/api/wit/work-items

Remove-Variable * -ErrorAction SilentlyContinue
Clear-Host

$tfsTeam = ''

#$tfsApiEndPoint = 'work/boards/Backlog%20items/rows'
#$tfsApiEndPoint = 'wit/workitems/146167'
#$tfsApiEndPoint = 'wit/workitems/157210'
$tfsApiEndPoint = 'wit/workitems/$Task'
#$tfsApiEndPoint = 'wit/workitems/$Product%20Backlog%20Item'

$tfsBazingaURL = ('http://localtfs:8080/tfs/{0}/_apis/{1}?$expand=all&api-version=2.0' -f $tfsTeam, $tfsApiEndPoint)

$Body = @"
[
    {
        "op": "test",
        "path": "/fields/System.Title",
        "value": "Test WZ"
    },
    {
        "op": "test",
        "path": "/fields/System.WorkItemType",
        "value": "Task"
    },
    {
        "op": "test",
        "path": "/fields/System.AreaPath",
        "value": "KO\\Control"
    },
    {
        "op": "test",
        "path": "/fields/System.IterationPath",
        "value": "KO\\Bazinga!\\Sprint 40"
    },
    {
        "op": "test",
        "path": "/fields/System.State",
        "value": "New"
    },
    {
        "op": "test",
        "path": "/relations/-",
        "value": {
            "rel": "System.LinkTypes.Hierarchy-Reverse",
            "url": "http://localtfs:8080/tfs/.../_apis/wit/workItems/146167",
            "attributes": {
                "comment": "Test WZ"
            }
        }
    }
]
"@

#$boards = Invoke-RestMethod -Method Get -Uri $tfsBazingaURL -UseDefaultCredentials
$boards = Invoke-RestMethod -Method Patch -Uri $tfsBazingaURL -Body (ConvertFrom-Json $Body) -ContentType 'application/json-patch+json' -UseDefaultCredentials
$boards.fields
foreach($baord in $boards.value){
    $baord
}
