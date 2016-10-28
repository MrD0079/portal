<?php
InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
$params=array(
	":dpt_id" => $_SESSION["dpt_id"],
	":tn"=>$tn,
	":exp_list_without_ts" => $_REQUEST["exp_list_without_ts"],
	":exp_list_only_ts" => $_REQUEST["exp_list_only_ts"],
	":eta" => "'".$_REQUEST["eta_list"]."'",
	":dt" => "'".$_REQUEST["month_list"]."'",
);
$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_only_ts', $exp_list_only_ts);
$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);
$sql = rtrim(file_get_contents('sql/eta_list.sql'));
$sql=stritr($sql,$params);
$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('eta_list', $eta_list);
$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);
if (isset($_REQUEST["generate"]))
{
$sql=rtrim(file_get_contents('sql/salesbyweek.sql'));
$sql=stritr($sql,$params);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);
$sql=rtrim(file_get_contents('sql/salesbyweekt.sql'));
$sql=stritr($sql,$params);
$listt = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('listt', $listt);
}
$smarty->display('salesbyweek.html');
