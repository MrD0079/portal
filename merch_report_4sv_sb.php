<?php

audit("открыл сводный отчет М-Сервис","merch_report_4sv_sb");

InitRequestVar("dates_list1",$_REQUEST["dates_list"]);
InitRequestVar("dates_list2",$_REQUEST["dates_list"]);
InitRequestVar("vp",0);
InitRequestVar("svms_list",0);
InitRequestVar("oblast","0");
InitRequestVar("nets",0);
InitRequestVar("city","0");
InitRequestVar("tz","0");
InitRequestVar("ok_kk",1);
InitRequestVar("ok_ms",1);


$sql = rtrim(file_get_contents('sql/dates_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dates_list', $res);

$sql=rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new_oblast.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('oblast', $data);

$sql=rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new_nets.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

$sql=rtrim(file_get_contents('sql/svms_list.sql'));
$p = array(":tn"=>$tn,':dpt_id'=>$_SESSION['dpt_id'],":login"=>"'".$login."'");
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('svms_list', $data);

$sql = rtrim(file_get_contents('sql/merch_report_vp_all.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('vp', $res);

$sql=rtrim(file_get_contents('sql/merch_report_4sv_sb_tz.sql'));
$p = array(":tn"=>$tn);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tz', $data);

$sql = rtrim(file_get_contents('sql/merch_report_4admin_by_spec_new_city.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('city', $res);

if (isset($_REQUEST["select"]))
{
$p=array(
":nets"=>$_REQUEST["nets"],
":tn"=>$tn,
":svms_list"=>$_REQUEST["svms_list"],
":vp"=>$_REQUEST["vp"],
":sd"=>"'".$_REQUEST["dates_list1"]."'",
":ed"=>"'".$_REQUEST["dates_list2"]."'",
":city"=>"'".$_REQUEST["city"]."'",
":oblast"=>"'".$_REQUEST["oblast"]."'",
":tz"=>"'".$_REQUEST["tz"]."'",
":ok_kk"=>$_REQUEST["ok_kk"],
":ok_ms"=>$_REQUEST["ok_ms"],
);
$sql = rtrim(file_get_contents('sql/merch_report_4sv_sb.sql'));
$sql=stritr($sql,$p);
$rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($rb as $k=>$v)
{
$p=array(
":head_id"=>$v["rh_id"],
":kod_tp"=>$v["rb_kodtp"],
":dt"=>"'".$v["sb_dt"]."'",
":vp"=>$_REQUEST["vp"],
);
$sql = rtrim(file_get_contents('sql/merch_report_4sv_sb_items.sql'));
$sql=stritr($sql,$p);
$rbd = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$rb[$k]['products']=$rbd;
}
$smarty->assign('d', $rb);
}

$smarty->display('merch_report_4sv_sb.html');

?>