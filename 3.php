<?php
header('Content-Type: text/html; charset="UTF-8"');
header("Cache-Control: no-store, no-cache,  must-revalidate"); 
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");

ini_set('display_errors', 'On');


?><pre><?
          	

ini_set("soap.wsdl_cache_enabled", "0");
$options = array(
	'trace' => true,
	'exceptions' => true,
	'cache_wsdl' => 'WSDL_CACHE_NONE',
	'soap_version' => 'SOAP_1_2'
);
try
{  
	//$client = new SoapClient("http://10.10.11.4/Orders/ws/Orders/?wsdl"/*,$options*/);
	$client = new SoapClient("http://scm.avk.company/SCM/ws/SCM_Exchange?wsdl"/*,$options*/);
//	var_dump($client->__getFunctions());
//	var_dump($client->__getTypes());
}
catch (Exception $e)
{ 
	echo $e->getMessage();
}  




$result = $client->ExecuteProcessing(
        array
        (
                'BinaryData'=>base64_encode(file_get_contents("sz_files/sz6013285.xls")),
                'Processing'=>'WebSendOrder',
                'StringData'=>'155582467'
        )
)->return;

echo "<pre>";
var_dump($result);
//var_dump($result->Result);
echo "</pre>";

/*
if (!$result->Result->Result)
{
echo $result->Result->Message;
}
*/


exit;
$error=0;
try {
$client = new 
    SoapClient( 
        "http://10.10.1.4/CreateClient/ws/CreateClient?wsdl" 
    ); 
 } catch (Exception $e) { 
$error=1;
}
echo'error con=';
print_r($error);
echo "\n";
$xmlStr='
<?xml version="1.0" encoding="UTF-8"?>
<root>
<CAgName>888</CAgName>
<CAgShortName>3333</CAgShortName>
<CAgNonresident>1</CAgNonresident>
<CAgNotVATpayer></CAgNotVATpayer>
<CAgBuyer></CAgBuyer>
<CAgSeller></CAgSeller>
<CAgNotNPpayer></CAgNotNPpayer>
</root>
';
try { 
$result = $client-> CreateClient1C($xmlStr);
print_r($result);
} catch (Exception $e) { 
print_r($e);
$error=1;
}
echo'error crt=';
print_r($error);
echo "\n";
?>