
## POST
#this is the url that you want will send thae request to
$url = "www.this-is-your-url"
#here you can set your POST params
$account = "pavelDurov"
$password = "123456"

$parameters = "accountName=" + $account + "&" + "password="+ $password
#creating the xmlHtpp system object              
$http_request = New-Object -ComObject Msxml2.XMLHTTP
$http_request.open('POST', $url, $false)
#Setting required header of the request
$http_request.setRequestHeader("Content-type", "application/x-www-form-urlencoded")
$http_request.setRequestHeader("Content-length", $parameters.length)
#Assigning the params to the request
$http_request.send($parameters)
#printing the request result
echo $http_request.statusText

## GET
#this is the url that you want will send thae request to
$url = "https://this-is-your-url.com"

#creating the xmlHtpp system object              
$http_request = New-Object -ComObject Msxml2.XMLHTTP
$http_request.open('GET', $url, $true)
#Sending the request
$http_request.send()

#printing the request result
echo $http_request.statusText