$web = Invoke-WebRequest http://blogs.msdn.com/b/powershell
$web.BaseResponse
$web.Forms | Format-List
$web.Images | Select -Property src
#$web.Links | Select -Property innerText,href

$PSIco = "http://www.wintellect.com/devcenter/wp-content/uploads/2015/11/powershell.png"
Invoke-WebRequest -Uri $PSIco -OutFile "PSIco.png"

$YTRestApi = "https://gdata.youtube.com/feeds/api/videos?v=2"
$YTQuery = "&q=" + "Paper+Wings"
Invoke-RestMethod "$YTRestApi$YTQuery"

Invoke-RestMethod "https://www.googleapis.com/youtube/v3/channels?part=contentDetails&mine=true"