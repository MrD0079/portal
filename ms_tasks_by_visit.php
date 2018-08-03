<?php

audit("открыл отчет М-Сервис Отчет по задачам","ms_tasks_by_visit");

InitRequestVar("period",1);
//InitRequestVar("dates_list2",$_REQUEST["month_list"]);
InitRequestVar("day_list",$now);
InitRequestVar("week_list",$now_week);
InitRequestVar("month_list",$_REQUEST["month_list"]);
InitRequestVar("select_route_numb",0);
InitRequestVar("select_route_fio_otv",0);
InitRequestVar("svms_list",0);
InitRequestVar("oblast","0");
InitRequestVar("nets",0);
InitRequestVar("agent",0);
InitRequestVar("city","0");



$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql = rtrim(file_get_contents('sql/week_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('week_list', $res);

$sql=rtrim(file_get_contents('sql/ms_tasks_by_visit_oblast.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('oblast', $data);

$sql=rtrim(file_get_contents('sql/ms_tasks_by_visit_nets.sql'));
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
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('city', $res);

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
":day_list"=>"'".$_REQUEST["day_list"]."'",
":week_list"=>"'".$_REQUEST["week_list"]."'",
":month_list"=>"'".$_REQUEST["month_list"]."'",
":city"=>"'".$_REQUEST["city"]."'",
":oblast"=>"'".$_REQUEST["oblast"]."'"
);

$sql = rtrim(file_get_contents('sql/ms_tasks_by_visit.sql'));
$sql=stritr($sql,$p);
$rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $rb);
$sql = rtrim(file_get_contents('sql/ms_tasks_by_visit_total.sql'));
$sql=stritr($sql,$p);
$rb = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('t', $rb);

}

$smarty->display('ms_tasks_by_visit.html');

?>