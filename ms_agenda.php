<?php

audit("открыл отчет М-Сервис дни визитов","ms_agenda");

InitRequestVar("period",1);
InitRequestVar("per_day",$now);
InitRequestVar("per_week",$now_week);
InitRequestVar("per_month",$now1);
InitRequestVar("select_route_numb",0);
InitRequestVar("select_route_fio_otv",0);
InitRequestVar("svms_list",0);
InitRequestVar("oblast","0");
InitRequestVar("nets",0);
InitRequestVar("agent",0);
InitRequestVar("city","0");

switch ($_REQUEST["period"]) {
	case 1: $period = $_REQUEST["per_day"]; break;
	case 2: $period = $_REQUEST["per_week"]; break;
	case 3: $period = $_REQUEST["per_month"]; break;
}



$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql = rtrim(file_get_contents('sql/week_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('week_list', $res);

$sql=rtrim(file_get_contents('sql/ms_agenda_oblast.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('oblast', $data);

$sql=rtrim(file_get_contents('sql/ms_agenda_nets.sql'));
$p = array(":ed"=>"'".$period."'");
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

$sql=rtrim(file_get_contents('sql/svms_list.sql'));
$p = array(":tn"=>$tn,':dpt_id'=>$_SESSION['dpt_id'],":login"=>"'".$login."'");
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('svms_list', $data);

$sql = rtrim(file_get_contents('sql/routes_agents.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head_agents', $res);

$sql = rtrim(file_get_contents('sql/merch_report_4admin_by_spec_new_city.sql'));
$p=array(":ed"=>"'".$period."'");
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('city', $res);

$sql = rtrim(file_get_contents('sql/ms_agenda_days.sql'));
$sql=stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('days', $r);


if (isset($_REQUEST["select"]))
{
$p=array(
":period"=>$_REQUEST["period"],
":agent"=>$_REQUEST["agent"],
":nets"=>$_REQUEST["nets"],
":tn"=>$tn,
//":select_route_numb"=>$_REQUEST["select_route_numb"],
//":select_route_fio_otv"=>$_REQUEST["select_route_fio_otv"],
":svms_list"=>$_REQUEST["svms_list"],
":ed"=>"'".$period."'",
":city"=>"'".$_REQUEST["city"]."'",
":oblast"=>"'".$_REQUEST["oblast"]."'",":login"=>"'".$login."'"
);

$sql = rtrim(file_get_contents('sql/ms_agenda.sql'));
$sql=stritr($sql,$p);
//echo $sql;
//exit;
$rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

//print_r($rb);
//exit;

$smarty->assign('d', $rb);

}

$smarty->display('ms_agenda.html');

?>