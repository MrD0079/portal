<?php
	InitRequestVar("exp_list_without_ts",0);
	InitRequestVar("exp_list_only_ts",0);
	InitRequestVar("region_list");
	InitRequestVar("eta_list",$_SESSION["h_eta"]);
	InitRequestVar("sd",$now);
	InitRequestVar("ed",$now);
	InitRequestVar("ok_visit",1);
	$params=array(
		':dpt_id' => $_SESSION["dpt_id"],
		':tn'=>$tn,
		':ok_visit' => $_REQUEST["ok_visit"],
		':eta_list' => "'".$_REQUEST["eta_list"]."'",
		':region_list' => "'".$_REQUEST["region_list"]."'",
		':sd' => "'".$_REQUEST["sd"]."'",
		':ed' => "'".$_REQUEST["ed"]."'",
		':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
		':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
	);
	$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
	$sql=stritr($sql,$params);
	$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('exp_list_only_ts', $exp_list_only_ts);
	$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
	$sql=stritr($sql,$params);
	$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('exp_list_without_ts', $exp_list_without_ts);
	$sql = rtrim(file_get_contents('sql/a14to_eta_list.sql'));
	$sql=stritr($sql,$params);
	$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('eta_list', $eta_list);
	$sql = rtrim(file_get_contents('sql/a14to_region_list.sql'));
	$sql=stritr($sql,$params);
	$region_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('region_list', $region_list);
	if (isset($_REQUEST['generate']))
	{
		$sql=rtrim(file_get_contents('sql/a14to_nophoto.sql'));
		$sql=stritr($sql,$params);
		$t = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('t', $t);
	}
	$smarty->display('a14to_nophoto.html');
?>