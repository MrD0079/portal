<?php


audit("открыл сводный отчет М-Сервис","merch_photo_report_new");

InitRequestVar("dates_list1",$_REQUEST["dates_list"]);
InitRequestVar("dates_list2",$_REQUEST["dates_list"]);
InitRequestVar("nets",0);
InitRequestVar("city",0);
InitRequestVar("oblast",0);
InitRequestVar("agent",0);


$sql=rtrim(file_get_contents('sql/merch_report_4admin_by_spec_new_oblast.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('oblast', $data);

$sql=rtrim(file_get_contents('sql/merch_report_4admin_by_spec_new_nets.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

$sql = rtrim(file_get_contents('sql/merch_report_4admin_by_spec_new_city.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('city', $res);




//ses_req();

$sql = rtrim(file_get_contents('sql/dates_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dates_list', $res);

$sql = rtrim(file_get_contents('sql/routes_agents.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head_agents', $res);


if ($_REQUEST["agent"]!=0&&isset($_REQUEST["select"]))
{
$p=array(
":agent"=>$_REQUEST["agent"],
":tn"=>$tn,
":sd"=>"'".$_REQUEST["dates_list1"]."'",
":ed"=>"'".$_REQUEST["dates_list2"]."'",
":nets"=>$_REQUEST["nets"],
":city"=>"'".$_REQUEST["city"]."'",
":oblast"=>"'".$_REQUEST["oblast"]."'",
);

$sql = rtrim(file_get_contents('sql/merch_photo_report_new.sql'));
$sql=stritr($sql,$p);
$rb1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);


//echo $sql;
//print_r($rb1);

//echo count($rb1);

$ag_name=translit($db->getOne("select name from routes_agents where id=".$_REQUEST["agent"]));

if (count($rb1)>0)
{
recursive_remove_directory("merch_photo_report_new_archives/".$tn,true);
$zip = new ZipArchive();
$archive="merch_photo_report_new_archives"."/".$tn."/".$ag_name."_".$_REQUEST["dates_list2"].".zip";
//echo $archive;
$zip->open($archive, ZIPARCHIVE::CREATE);
$file_list=array();
foreach ($rb1 as $k=>$v){
$d1="merch_photo_report_new_archives";
$d2=$d1."/".$tn;
$d3=$d2."/".translit($v["ag_name"]);
$d4=$d3."/".translit($v["tz_oblast"]);
$d5=$d4."/".translit($v["net_name"]);
$d6=$d5."/".preg_replace('/\W+/', '_', translit($v["tz_address"]));
$d7=$d6."/".translit($v["dt"]);
if (!file_exists($d1)) {mkdir($d1);}
if (!file_exists($d2)) {mkdir($d2);}
if (!file_exists($d3)) {mkdir($d3);}
if (!file_exists($d4)) {mkdir($d4);}
if (!file_exists($d5)) {mkdir($d5);}
if (!file_exists($d6)) {mkdir($d6);}
if (!file_exists($d7)) {mkdir($d7);}

$p1=
translit($v["ag_name"])."/".
translit($v["tz_oblast"])."/".
translit($v["net_name"])."/".
translit(preg_replace('/\W+/', '_', translit($v["tz_address"])))."/".
translit($v["dt"])
;

$d1="merch_spec_report_files";
$d2=$d1."/".$v["dt"];
$d3=$d2."/".$v["ag_id"];
$d4=$d3."/".$v["kodtp"];
if (!file_exists($d1)) {mkdir($d1);}
if (!file_exists($d2)) {mkdir($d2);}
if (!file_exists($d3)) {mkdir($d3);}
if (!file_exists($d4)) {mkdir($d4);}
if ($handle = opendir($d4)) {
	while (false !== ($file = readdir($handle)))
	{
		if ($file != "." && $file != "..")
		{
			$file_list[] = array("path"=>$d4,"file"=>$file);

			//echo $d4."/".$file."=>".$d7."/".$file."<br>";
			copy ($d4."/".$file,$d7."/".$file);
			//$zip->open($archive, ZIPARCHIVE::CREATE);
			$zip->addFile($d7."/".$file, $p1."/".$file);
			//$zip->close();
		}
	}
	closedir($handle);
}
}
$zip->close();
if (count($file_list)>0)
{
$smarty->assign('archive', $archive);
}
recursive_remove_directory("merch_photo_report_new_archives/".$tn."/".$ag_name,true);
rmdir("merch_photo_report_new_archives/".$tn."/".$ag_name);
}
}
$smarty->display('merch_photo_report_new.html');

?>