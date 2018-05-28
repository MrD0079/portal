<?php

audit("открыл сводный отчет М-Сервис","merch_report_4sv_by_spec_new");

InitRequestVar("dates_list1",$_REQUEST["dates_list"]);
InitRequestVar("dates_list2",$_REQUEST["dates_list"]);
//InitRequestVar("select_route_numb",0);
//InitRequestVar("select_route_fio_otv",0);
//InitRequestVar("svms_list",0);
InitRequestVar("oblast","0");
InitRequestVar("nets",0);
InitRequestVar("agent",0);
InitRequestVar("city","0");
InitRequestVar("flt_chat",0);

//ses_req();

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
$p=array(":tn"=>$tn,":ed"=>"'".$_REQUEST["dates_list2"]."'");
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head', $res);

$sql = rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new_routes_head_fio_otv.sql'));
$p=array(":tn"=>$tn,":ed"=>"'".$_REQUEST["dates_list2"]."'");
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
//":select_route_numb"=>$_REQUEST["select_route_numb"],
//":select_route_fio_otv"=>$_REQUEST["select_route_fio_otv"],
//":svms_list"=>$_REQUEST["svms_list"],
":sd"=>"'".$_REQUEST["dates_list1"]."'",
":ed"=>"'".$_REQUEST["dates_list2"]."'",
":city"=>"'".$_REQUEST["city"]."'",
":oblast"=>"'".$_REQUEST["oblast"]."'",
":flt_chat"=>$_REQUEST["flt_chat"],
);


$sql = rtrim(file_get_contents('sql/merch_report_4sv_file_chat.sql'));
$sql=stritr($sql,$p);
//echo $sql;
$rbf = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($rbf as $k=>$v)
{
	$d[$v["dt"].'.'.$v["kodtp"]]["head"]=$v;
	$d[$v["dt"].'.'.$v["kodtp"]]["data"][$v["ag_id"]]["head"]=$v;
	$d[$v["dt"].'.'.$v["kodtp"]]["data"][$v["ag_id"]]["data"]["z"]=$v;
	isset($v["msr_file_id"])?$d[$v["dt"].'.'.$v["kodtp"]]["data"][$v["ag_id"]]["data"]["file_list"][]=$v:null;
	//$d[$v["dt"].'.'.$v["kodtp"]]["head"]=$v;
	//$d[$v["dt"].'.'.$v["kodtp"]]["files"][]=$v;
}


//print_r($d);


isset($d) ? $smarty->assign('d', $d) : null;


}


//ses_req();

$smarty->display('merch_report_4sv_file_chat.html');

?>