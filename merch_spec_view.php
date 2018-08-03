<?php
//audit("просмотрел спецификацию","merch_spec");

$sql = rtrim(file_get_contents('sql/merch_spec_body.sql'));
$p=array(":head_id"=>$_REQUEST["head_id"]);
$sql=stritr($sql,$p);
//echo $sql;
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('merch_spec_body', $res);
//print_r($res);
$sql = rtrim(file_get_contents('sql/merch_spec_body_total.sql'));
$p=array(":head_id"=>$_REQUEST["head_id"]);
$sql=stritr($sql,$p);
//echo $sql;
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('merch_spec_body_total', $res);
//print_r($res);
$smarty->assign('net_name', $db->getOne("select net_name from ms_nets where id_net=".$_REQUEST["id_net"]));
$smarty->assign('ag_name', $db->getOne("select name from routes_agents where id=".$_REQUEST["ag_id"]));
$smarty->assign('tz_name', $db->getOne("select distinct ur_tz_name from cpp where kodtp=".$_REQUEST["kod_tp"]));
$smarty->display('merch_spec_view.html');
?>