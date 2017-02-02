<?php
putenv("NLS_LANG=RUSSIAN_CIS.CL8MSWIN1251");
require_once "../function.php";
$link = OCILogon("persik", "razvitie", ZAOIBM);
$q = file_get_contents("get_routes.sql");
$r = OCIParse($link, $q);
OCIExecute($r);
$routes=array();
$i=1;
while (OCIFetch($r))
{
$routes[$i]["oblast"]=OCIResult($r, 1);
$routes[$i]["route"]=OCIResult($r, 2);
$routes[$i]["net"]=OCIResult($r, 3);
$routes[$i]["address"]=OCIResult($r, 4);
$routes[$i]["id"]=OCIResult($r, 5);
$i++;
}
foreach($routes as $k=>$v)
{
foreach($v as $k1=>$v1)
{
$routes[$k][$k1]=iconv('cp1251','utf-8',$v1);
}
}
// function defination to convert array to xml
function array_to_xml($routes, &$xml_routes) {
    foreach($routes as $key => $value) {
        if(is_array($value)) {
            if(!is_numeric($key)){
                $subnode = $xml_routes->addChild("$key");
                array_to_xml($value, $subnode);
            }
            else{
                $subnode = $xml_routes->addChild("item$key");
                array_to_xml($value, $subnode);
            }
        }
        else {
            $xml_routes->addChild("$key","$value");
        }
    }
}

// creating object of SimpleXMLElement
$xml_routes = new SimpleXMLElement("<?xml version=\"1.0\" encoding=\"utf-8\"?><routes></routes>");
// function call to convert array to xml
array_to_xml($routes,$xml_routes);
//saving generated xml file
$xml_routes->asXML('output/routes.xml');


?>
