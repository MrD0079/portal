<?php
audit(pathinfo(__FILE__)["filename"],pathinfo(__FILE__)["filename"]);
//audit("открыл табель М-Сервис","ms_tabel");

InitRequestVar("month_list",$_REQUEST["month_list"]);
InitRequestVar("numb",0);
InitRequestVar("fio_otv",0);
InitRequestVar("svms_list",0);
InitRequestVar("oblast","0");
InitRequestVar("city","0");

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql=rtrim(file_get_contents('sql/merch_report_4admin_by_spec_new_nets.sql'));
$p = array(":ed"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

$sql=rtrim(file_get_contents('sql/svms_list.sql'));
$p = array(":tn"=>$tn,':dpt_id'=>$_SESSION['dpt_id']);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('svms_list', $data);

$sql = rtrim(file_get_contents('sql/ms_tabel_routes_head.sql'));
$p=array(":tn"=>$tn,":ed"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head', $res);

$sql = rtrim(file_get_contents('sql/ms_tabel_routes_head_fio_otv.sql'));
$p=array(":tn"=>$tn,":ed"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head_fio_otv', $res);

$sql = rtrim(file_get_contents('sql/routes_agents.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head_agents', $res);

if (isset($_REQUEST["select"]))
{
$p=array(
":tn"=>$tn,
":numb"=>$_REQUEST["numb"],
":fio_otv"=>"'".$_REQUEST["fio_otv"]."'",
":svms_list"=>$_REQUEST["svms_list"],
":ed"=>"'".$_REQUEST["month_list"]."'",
);


$sql = rtrim(file_get_contents('sql/ms_tabel.sql'));
$sql=stritr($sql,$p);
//echo $sql;
$rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

$sqld = rtrim(file_get_contents('sql/ms_tabel_detail.sql'));

foreach ($rb as $k=>$v)
{
$p[":head_id"]=$v['id'];
$sql=stritr($sqld,$p);
$rb[$k]['detail'] = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
}
$smarty->assign('d', $rb);

$sql = rtrim(file_get_contents('sql/ms_tabel_days.sql'));
$sql=stritr($sql,$p);

//echo $sql;

$days = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('days', $days);

//print_r($days);

}

$smarty->assign('ok_nmms', $db->getOne("select ok_nmms from ms_tabel_dt where dt=TO_DATE('".$_REQUEST["month_list"]."','dd.mm.yyyy')"));
$smarty->assign('ok_nmms_lu', $db->getOne("select to_char(lu,'dd.mm.yyyy hh24:mi:ss') from ms_tabel_dt where dt=TO_DATE('".$_REQUEST["month_list"]."','dd.mm.yyyy')"));

$smarty->display('ms_tabel.html');

?>