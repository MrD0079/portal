<?php



audit("открыл сводный отчет М-Сервис","merch_report_4admin_by_spec_new");

InitRequestVar("dates_list2",$_REQUEST["dates_list"]);
InitRequestVar("select_route_numb",0);
InitRequestVar("svms_list",0);
InitRequestVar("oblast","0");
InitRequestVar("nets",0);
InitRequestVar("agent",0);
InitRequestVar("city","0");

$sql=rtrim(file_get_contents('sql/merch_report_4admin_by_spec_new_oblast.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('oblast', $data);

$sql=rtrim(file_get_contents('sql/merch_report_4admin_by_spec_new_nets.sql'));
$p = array(":ed"=>"'".$_REQUEST["dates_list2"]."'");
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

$sql=rtrim(file_get_contents('sql/svms_list.sql'));
$p = array(":tn"=>$tn,':dpt_id'=>$_SESSION['dpt_id'],":login"=>"'".$login."'");
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('svms_list', $data);

$sql = rtrim(file_get_contents('sql/merch_report_4admin_by_spec_new_city.sql'));
$p=array(":ed"=>"'".$_REQUEST["dates_list2"]."'");
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('city', $res);

$sql = rtrim(file_get_contents('sql/routes_agents.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head_agents', $res);




if (isset($_REQUEST["select"]))
{
$p=array(
":agent"=>$_REQUEST["agent"],
":nets"=>$_REQUEST["nets"],
":city"=>"'".$_REQUEST["city"]."'",
":svms_list"=>$_REQUEST["svms_list"],
":ed"=>"'".$_REQUEST["dates_list2"]."'",
":oblast"=>"'".$_REQUEST["oblast"]."'"
);


$sql = rtrim(file_get_contents('sql/merch_report_4admin_by_spec_new.sql'));
$sql=stritr($sql,$p);
//$_REQUEST["sql"]=$sql;
//echo $sql;
//exit;
$rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

//print_r($rb);

foreach ($rb as $k=>$v){
$d[$v["dt"]]["data"][$v["tz_oblast"]]["data"][$v["city"]]["data"][$v["net_name"]]["data"][$v["ur_tz_name"]]["data"][$v["tz_address"]]["data"][$v["msr_id"]]=$v;
//$d1[$v["dt"]]["data"][$v["tz_oblast"]]["data"][$v["city"]]["data"][$v["net_name"]]["data"][$v["ur_tz_name"]]["head"]["kodtp"]=$v["kodtp"];
}

//print_r($d);

if (!isset($_REQUEST["print"]))
{

$sql = rtrim(file_get_contents('sql/merch_report_4admin_by_spec_new_files.sql'));
$sql=stritr($sql,$p);
$files = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//$_REQUEST["sqlf"]=$sql;

//ses_req();

recursive_remove_directory("merch_spec_report_archives/".$tn,true);
if (!file_exists("merch_spec_report_archives/".$tn)) {mkdir("merch_spec_report_archives/".$tn,0777,true);}


foreach ($files as $k=>$v)
{
	$v["path"]="merch_spec_report_files/".$v["path"];
	$d[$v["dt"]]["data"][$v["tz_oblast"]]["data"][$v["city"]]["data"][$v["net_name"]]["data"][$v["ur_tz_name"]]["data"][$v["tz_address"]]["files"][]=$v;

	$zip = new ZipArchive();
	$archive="merch_spec_report_archives/".$tn."/".$_REQUEST["dates_list2"]."_".translit($v["tz_address"])."."."zip";

	$zip->open($archive, ZIPARCHIVE::CREATE);
	$zip->addFile("merch_spec_report_files/".$v["dt"]."/".$_REQUEST["agent"]."/".$v["kodtp"]."/".$v["fn"], translit($v["tz_oblast"])."/".translit($v["net_name"])."/".translit($v["dt"])."/".$v["fn"]);
	$zip->close();

	$d[$v["dt"]]["data"][$v["tz_oblast"]]["data"][$v["city"]]["data"][$v["net_name"]]["data"][$v["ur_tz_name"]]["data"][$v["tz_address"]]["archive"]=$archive;
}
}

}

isset($d) ? $smarty->assign('d', $d) : null;

$sql = rtrim(file_get_contents('sql/merch_report_4admin_by_spec_new5.sql'));
$sql=stritr($sql,$p);
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('rb_total', $res);
//$_REQUEST["sqlt"]=$sql;

//ses_req();

$sql = rtrim(file_get_contents('sql/merch_spec_report_fields.sql'));
$p=array(":ag_id"=>$_REQUEST["agent"]);
$sql=stritr($sql,$p);
$fields = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('merch_spec_report_fields', $fields);

$smarty->display('merch_report_4admin_by_spec_new.html');

?>