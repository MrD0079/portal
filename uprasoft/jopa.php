<?php
putenv("NLS_LANG=RUSSIAN_CIS.CL8MSWIN1251");
require_once "../function.php";
require_once "xml2array.php";
$link = oci_connect("persik", "razvitie", ZAOIBM);
$q = "
INSERT INTO PERSIK.MERCH_REPORT_GPS
(DT, KOD_AG, KOD_TP, TIME_IN, TIME_OUT, TP_NAME, KOD_LOGGER)
VALUES
(TO_DATE(:DT,'YYYYMMDD'), :KOD_AG, :KOD_TP, TO_DATE(:TIME_IN,'YYYYMMDD HH24:MI'), TO_DATE(:TIME_OUT,'YYYYMMDD HH24:MI'), :TP_NAME, :KOD_LOGGER)
";
$q1 = "delete from PERSIK.MERCH_REPORT_GPS where DT=TO_DATE(:DT,'YYYYMMDD') and KOD_LOGGER =:KOD_LOGGER";
$r = oci_parse($link, $q);
$r1 = oci_parse($link, $q1);
oci_bind_by_name($r, ":DT", $dt, 8);
oci_bind_by_name($r, ":KOD_AG", $kod_ag, 1024);
oci_bind_by_name($r, ":KOD_TP", $kod_tp, 32);
oci_bind_by_name($r, ":TIME_IN", $time_in, 32);
oci_bind_by_name($r, ":TIME_OUT", $time_out, 32);
oci_bind_by_name($r, ":TP_NAME", $tp_name, 1024);
oci_bind_by_name($r, ":KOD_LOGGER", $kod_logger, 255);
oci_bind_by_name($r1, ":DT", $dt, 8);
oci_bind_by_name($r1, ":KOD_LOGGER", $kod_logger, 255);
if (count(glob("output/20*.xml")) == 0)
exit;
//echo "<table border=1>";
foreach(glob("output/20*.xml") as $key => $val) {
	$db = null;
	$rc = 0;
	rename($val, strtolower($val));
	$val = strtolower($val);
	$b = basename($val);
	//if ($b!='routes.xml') {
		//echo "FileName: " . /*iconv('cp1251','utf-8',$b)*/$b . " - ";
		$uploadfile = $val;
		$xml = file_get_contents(strtolower($uploadfile));
		$xml = xml2array ($xml);
		//print_r($xml);
		//$xml = GetXMLTree ($xml);
		$dt=substr($b,0,8);
		//echo strlen(iconv('utf-8','cp1251',$b))." * ".$b."\n";
		$kod_logger=substr(iconv('utf-8','cp1251',$b),9,strlen(iconv('utf-8','cp1251',$b))-13);
		oci_execute($r1);
		$i=0;
		foreach ($xml["Workbook"]["Worksheet"]["Table"]["Row"] as $k=>$v)
		{
			if ($i>0){
			/*echo "<tr>";
			foreach ($v["Cell"] as $k1=>$v1)
			{
				echo "<td>";
				echo iconv('utf-8','cp1251',$v1["Data"]);
				echo "</td>";
			}
			echo "</tr>";*/
			$kod_ag=iconv('utf-8','cp1251',$v["Cell"][0]["Data"]);
			$kod_tp=iconv('utf-8','cp1251',$v["Cell"][1]["Data"]);
			$tp_name=iconv('utf-8','cp1251',$v["Cell"][2]["Data"]);
			$time_in=$dt.' '.$v["Cell"][3]["Data"];
			$time_out=$dt.' '.$v["Cell"][4]["Data"];
			oci_execute($r);
			}
			$i++;
		}
		rename($val,'Loaded/'.$b);
	//}
}
//echo "</table>";
