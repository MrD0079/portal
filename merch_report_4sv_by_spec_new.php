<?php
audit("открыл сводный отчет М-Сервис","merch_report_4sv_by_spec_new");

InitRequestVar("dates_list2",$_REQUEST["dates_list"]);
InitRequestVar("select_route_numb",0);
InitRequestVar("select_route_fio_otv",0);
InitRequestVar("svms_list",0);
InitRequestVar("oblast","0");
InitRequestVar("nets",0);
InitRequestVar("agent",0);
InitRequestVar("city","0");

$sql = rtrim(file_get_contents('sql/dates_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dates_list', $res);

$sql=rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new_oblast.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('oblast', $data);

$sql=rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new_nets.sql'));
$p = array(":ed"=>"'".$_REQUEST["dates_list2"]."'");
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

$sql=rtrim(file_get_contents('sql/svms_list.sql'));
$p = array(":tn"=>$tn,':dpt_id'=>$_SESSION['dpt_id'],":login"=>"'".$login."'");
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('svms_list', $data);

$sql = rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new_routes_head.sql'));
$p=array(":tn"=>$tn,":ed"=>"'".$_REQUEST["dates_list2"]."'",":login"=>"'".$login."'");
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head', $res);

$sql = rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new_routes_head_fio_otv.sql'));
$p=array(":tn"=>$tn,":ed"=>"'".$_REQUEST["dates_list2"]."'",":login"=>"'".$login."'");
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head_fio_otv', $res);

$sql = rtrim(file_get_contents('sql/routes_agents.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head_agents', $res);

$sql = rtrim(file_get_contents('sql/merch_report_4admin_by_spec_new_city.sql'));
$p=array(":ed"=>"'".$_REQUEST["dates_list2"]."'");
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('city', $res);


if (isset($_REQUEST["select"]))
{
$p=array(
":agent"=>$_REQUEST["agent"],
":nets"=>$_REQUEST["nets"],
":tn"=>$tn,
":select_route_numb"=>$_REQUEST["select_route_numb"],
":select_route_fio_otv"=>$_REQUEST["select_route_fio_otv"],
":svms_list"=>$_REQUEST["svms_list"],
":ed"=>"'".$_REQUEST["dates_list2"]."'",
":city"=>"'".$_REQUEST["city"]."'",
":oblast"=>"'".$_REQUEST["oblast"]."'",":login"=>"'".$login."'"
);


$sql = rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new.sql'));
$sql=stritr($sql,$p);
//echo $sql;
//$_REQUEST["sql"]=$sql;

//exit;
$rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

//print_r($rb);
//exit;



$sql = rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new_files.sql'));
$sql=stritr($sql,$p);
//echo $sql;
$rbf = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);


foreach ($rb as $k=>$v){
$d[$v["dt"].$v["svms_name"].$v["num"].$v["fio_otv"]]["head"]=$v;
$d[$v["dt"].$v["svms_name"].$v["num"].$v["fio_otv"]]["data"][$v["tz_oblast"].$v["city"].$v["net_name"].$v["ur_tz_name"].$v["tz_address"]]["head"]=$v;
$d[$v["dt"].$v["svms_name"].$v["num"].$v["fio_otv"]]["data"][$v["tz_oblast"].$v["city"].$v["net_name"].$v["ur_tz_name"].$v["tz_address"]]["data"][$v["ag_id"]]["head"]=$v;
$d[$v["dt"].$v["svms_name"].$v["num"].$v["fio_otv"]]["data"][$v["tz_oblast"].$v["city"].$v["net_name"].$v["ur_tz_name"].$v["tz_address"]]["data"][$v["ag_id"]]["data"][$v["msr_id"]]=$v;
}


//print_r($rbf);


foreach ($rbf as $k=>$v)
{
//	$d[$v["dt"].$v["svms_name"].$v["num"].$v["fio_otv"]]["data"][$v["tz_oblast"].$v["city"].$v["net_name"].$v["ur_tz_name"].$v["tz_address"]]["files"][]=$v;
	$d[$v["dt"].$v["svms_name"].$v["num"].$v["fio_otv"]]["data"][$v["tz_oblast"].$v["city"].$v["net_name"].$v["ur_tz_name"].$v["tz_address"]]["data"][$v["ag_id"]]["head"]["file_list"][$v["msr_file_id"]]=$v;
}


//print_r($d);

$zip = new ZipArchive();

recursive_remove_directory("files/merch_spec_report_archives/".$tn,true);

foreach ($rb as $k=>$v){

$d1="files/merch_spec_report_archives";
$d2=$d1."/".$tn;
$d3=$d2."/".translit($v["ag_name"]);
$d4=$d3."/".translit($v["tz_oblast"]);
$d5=$d4."/".translit($v["net_name"]);
$d6=$d5."/".translit($v["dt"]);
if (!file_exists($d1)) {mkdir($d1);}
if (!file_exists($d2)) {mkdir($d2);}
if (!file_exists($d3)) {mkdir($d3);}
if (!file_exists($d4)) {mkdir($d4);}
if (!file_exists($d5)) {mkdir($d5);}
if (!file_exists($d6)) {mkdir($d6);}

$p1=translit($v["ag_name"])."/".translit($v["tz_oblast"])."/".translit($v["net_name"])."/".translit($v["dt"]);

$archive=$d2."/".$_REQUEST["dates_list2"]."_".translit($v["tz_address"])."."."zip";

$d1="files/merch_spec_report_files";
$d2=$d1."/".$v["dt"];
$d3=$d2."/".$v["ag_id"];
$d4=$d3."/".$v["kodtp"];
if (!file_exists($d1)) {mkdir($d1);}
if (!file_exists($d2)) {mkdir($d2);}
if (!file_exists($d3)) {mkdir($d3);}
if (!file_exists($d4)) {mkdir($d4);}



$zip->open($archive, ZIPARCHIVE::CREATE);
 
$file_list=array();
if ($handle = opendir($d4)) {
	while (false !== ($file = readdir($handle)))
	{
		if ($file != "." && $file != "..")
		{
			$file_list[] = array("path"=>$d4,"file"=>$file);

			//echo $d4."/".$file."=>".$d5."/".$file."<br>";
			copy ($d4."/".$file,$d6."/".$file);
			$zip->addFile($d6."/".$file, $p1."/".$file);
		}
	}
	closedir($handle);
}

$zip->close();

//if (count($file_list))
$d[$v["dt"].$v["svms_name"].$v["num"].$v["fio_otv"]]["data"][$v["tz_oblast"].$v["city"].$v["net_name"].$v["ur_tz_name"].$v["tz_address"]]["head"]["archive"]=$archive;
//$d[$v["dt"].$v["svms_name"].$v["num"].$v["fio_otv"]]["data"][$v["tz_oblast"].$v["city"].$v["net_name"].$v["ur_tz_name"].$v["tz_address"]]["data"][$v["ag_id"]]["head"]["file_list"]=$file_list;

}

isset($d) ? $smarty->assign('d', $d) : null;


//print_r($d);

$sql = rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new4.sql'));
$sql=stritr($sql,$p);
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('rb_total', $res);

$sql = rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new_fields.sql'));
$sql = strtr(strtolower($sql), $p);
$fields = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('merch_spec_report_fields', $fields);


}

$smarty->display('merch_report_4sv_by_spec_new.html');

?>