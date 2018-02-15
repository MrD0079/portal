<?php
putenv("NLS_LANG=RUSSIAN_CIS.CL8MSWIN1251");
require_once "../function.php";
require_once "xml2array.php";
$xml = file_get_contents("PointsOrig.kml");
$xml = xml2array ($xml);
//$xml = file_get_contents("waypoints.gpx");
//print_r($xml);
$s="<?xml version='1.0' encoding='UTF-8'?>
<kml xmlns='http://www.opengis.net/kml/2.2'>
	<Document>
		<name>Points</name>
";
$Camping=$s;
$Ferry=$s;
$Parking=$s;
$Motoparking=$s;
$Laavu=$s;
$Tbana=$s;
$Points=$s;

$Camping.="		<metadata><igoicon><filename>camping.bmp</filename></igoicon></metadata>";
$Ferry.="		<metadata><igoicon><filename>ferry.bmp</filename></igoicon></metadata>";
$Parking.="		<metadata><igoicon><filename>parking.bmp</filename></igoicon></metadata>";
$Motoparking.="		<metadata><igoicon><filename>motoparking.bmp</filename></igoicon></metadata>";
$Laavu.="		<metadata><igoicon><filename>laavu.bmp</filename></igoicon></metadata>";
$Tbana.="		<metadata><igoicon><filename>tbana.bmp</filename></igoicon></metadata>";
$Points.="		<metadata><igoicon><filename>points.bmp</filename></igoicon></metadata>";


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
	//$x = explode(',',$v["Point"]["coordinates"]);
	//print_r($x);
	isset($v["description"]) ? $d=$v["description"] : $d=null;
	$x = "		<Placemark>
			<name>".$v["name"]."</name>
			<description><![CDATA[".$d."]]></description>
			<Point>
				<coordinates>".$v["Point"]["coordinates"]."</coordinates>
			</Point>
		</Placemark>
";
	if (startsWith($v["name"], "Camping")) {$Camping.=$x;}
	else if (startsWith($v["name"], "Ferry")) {$Ferry.=$x;}
	else if (startsWith($v["name"], "Parking")) {$Parking.=$x;}
	else if (startsWith($v["name"], "Moto parking")) {$Motoparking.=$x;}
	else if (startsWith($v["name"], "Laavu")) {$Laavu.=$x;}
	else if (startsWith($v["name"], "T-bana")) {$Tbana.=$x;}
	else {$Points.=$x;}
	
	//	echo "</tr>";
//	$name=iconv('utf-8','cp1251',$v["Cell"][0]["Data"]);
//	$kod_tp=iconv('utf-8','cp1251',$v["Cell"][1]["Data"]);
//	$tp_name=iconv('utf-8','cp1251',$v["Cell"][2]["Data"]);
}


$s="	</Document>
</kml>";
$Camping.=$s;
$Ferry.=$s;
$Parking.=$s;
$Motoparking.=$s;
$Laavu.=$s;
$Tbana.=$s;
$Points.=$s;

//echo "</table>";
$f=fopen('Camping.kml',"w+");fwrite($f,$Camping);fclose($f);
$f=fopen('Ferry.kml',"w+");fwrite($f,$Ferry);fclose($f);
$f=fopen('Parking.kml',"w+");fwrite($f,$Parking);fclose($f);
$f=fopen('Motoparking.kml',"w+");fwrite($f,$Motoparking);fclose($f);
$f=fopen('Laavu.kml',"w+");fwrite($f,$Laavu);fclose($f);
$f=fopen('Tbana.kml',"w+");fwrite($f,$Tbana);fclose($f);
$f=fopen('Points.kml',"w+");fwrite($f,$Points);fclose($f);

?>
