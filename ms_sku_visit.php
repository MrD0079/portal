<?php

audit("открыл отчет М-Сервис дни визитов","ms_sku_visit");

InitRequestVar("period",1);
InitRequestVar("dates_list2");
InitRequestVar("select_route_numb",0);
InitRequestVar("select_route_fio_otv",0);
InitRequestVar("svms_list",0);
InitRequestVar("oblast","0");
InitRequestVar("nets",0);
InitRequestVar("agent",0);
InitRequestVar("city","0");

//ses_req();

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql = rtrim(file_get_contents('sql/week_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('week_list', $res);

$sql=rtrim(file_get_contents('sql/ms_sku_visit_oblast.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('oblast', $data);

$sql=rtrim(file_get_contents('sql/ms_sku_visit_nets.sql'));
$p = array(":ed"=>"'".$_REQUEST["dates_list2"]."'");
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

$sql=rtrim(file_get_contents('sql/svms_list.sql'));
$p = array(":tn"=>$tn,':dpt_id'=>$_SESSION['dpt_id']);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('svms_list', $data);

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
":period"=>$_REQUEST["period"],
":agent"=>$_REQUEST["agent"],
":nets"=>$_REQUEST["nets"],
":tn"=>$tn,
//":select_route_numb"=>$_REQUEST["select_route_numb"],
//":select_route_fio_otv"=>$_REQUEST["select_route_fio_otv"],
":svms_list"=>$_REQUEST["svms_list"],
":ed"=>"'".$_REQUEST["dates_list2"]."'",
":city"=>"'".$_REQUEST["city"]."'",
":oblast"=>"'".$_REQUEST["oblast"]."'"
);

$sql = rtrim(file_get_contents('sql/ms_sku_visit.sql'));
$sql=stritr($sql,$p);
//echo $sql;
//exit;
$rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

//print_r($rb);
//exit;

$smarty->assign('d', $rb);

}

$smarty->display('ms_sku_visit.html');

?>