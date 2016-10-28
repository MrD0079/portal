<?php
header('Content-Type: text/html; charset="UTF-8"');
header("Cache-Control: no-store, no-cache,  must-revalidate"); 
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
?><pre><?
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