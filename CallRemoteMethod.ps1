$Uri = 'http://www.webservicex.net/geoipservice.asmx?WSDL'
$GeoIPWebService = New-WebServiceProxy -Uri $Uri -Namespace myWebServiceProxy
$GeoIPWebService.GetGeoIP('89.70.116.229')
$GeoIPWebService.GetGeoIPContext()

$Uri = 'http://www.webservicex.net/stockquote.asmx?WSDL'
$StockQuote = New-WebServiceProxy -Uri $Uri -Namespace myWebServiceProxy
$StockQuote.GetQuote('MSFT')