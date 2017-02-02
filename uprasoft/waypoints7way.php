<?php
putenv("NLS_LANG=RUSSIAN_CIS.CL8MSWIN1251");
require_once "../function.php";
require_once "xml2array.php";
$xml = file_get_contents("Points.kml");
$xml = xml2array ($xml);
//$xml = file_get_contents("waypoints.gpx");
//print_r($xml);
$s='<?xml version="1.0" encoding="UTF-8"?>
<gpx xmlns="http://www.topografix.com/GPX/1/1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd" version="1.1" creator="Navikey 7 Ways">
<metadata><time>2016-06-19T17:02:10Z</time></metadata>';
//echo "<table>";

function startsWith($haystack, $needle)
{
     $length = strlen($needle);
     return (substr($haystack, 0, $length) === $needle);
}

foreach ($xml["kml"]["Document"]["Placemark"] as $k=>$v)
{
	/*echo "<tr>";
	foreach ($v["Cell"] as $k1=>$v1)
	{
		echo "<td>";
		echo iconv('utf-8','cp1251',$v1["Data"]);
		echo "</td>";
	}*/
	$x = split(',',$v["Point"]["coordinates"]);
	//print_r($x);

	$type=11264;
	startsWith($v["name"], "Camping") ? $type=11008 : null;
	startsWith($v["name"], "Ferry") ? $type=4608 : null;
	startsWith($v["name"], "Parking") ? $type=12043 : null;
	startsWith($v["name"], "Moto parking") ? $type=12043 : null;
	startsWith($v["name"], "Laavu") ? $type=16640 : null;
	startsWith($v["name"], "T-bana") ? $type=61445 : null;
	
	
	isset($v["description"]) ? $d=str_ireplace("<br>", " ", $v["description"]) : $d=null;
	
	$s.= '
<wpt lat="'.$x[1].'" lon="'.$x[0].'">
<name>'.str_ireplace("<br>", " ", $v["name"]).'</name>
<desc>'.$d.'</desc>
<type>'.$type.'</type>
</wpt>';
	
	
	//	echo "</tr>";
//	$name=iconv('utf-8','cp1251',$v["Cell"][0]["Data"]);
//	$kod_tp=iconv('utf-8','cp1251',$v["Cell"][1]["Data"]);
//	$tp_name=iconv('utf-8','cp1251',$v["Cell"][2]["Data"]);
}


$s.='</gpx>';
//echo "</table>";
$f=fopen('waypoints.gpx',"w+");
fwrite($f,$s);
fclose($f);

?>
