<?php
	InitRequestVar("exp_list_without_ts",0);
	InitRequestVar("exp_list_only_ts",0);
	InitRequestVar("region_list");
	InitRequestVar("eta_list",$_SESSION["h_eta"]);
	InitRequestVar("sd",$now);
	InitRequestVar("ed",$now);
	InitRequestVar("ok_photo",1);
	InitRequestVar("ok_visit",1);
	InitRequestVar("ok_ts",1);
	InitRequestVar("ok_auditor",1);
	InitRequestVar("st_ts",1);
	InitRequestVar("st_auditor",1);
	InitRequestVar("by_who",'eta');
	$params=array(
		':dpt_id' => $_SESSION["dpt_id"],
		':tn'=>$tn,
		':ok_photo' => $_REQUEST["ok_photo"],
		':ok_visit' => $_REQUEST["ok_visit"],
		':ok_ts' => $_REQUEST["ok_ts"],
		':ok_auditor' => $_REQUEST["ok_auditor"],
		':st_ts' => $_REQUEST["st_ts"],
		':st_auditor' => $_REQUEST["st_auditor"],
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
		$sql=rtrim(file_get_contents('sql/a14to_stat_'.$_REQUEST['by_who'].'.sql'));
		$sql=stritr($sql,$params);
//echo $sql;
		$t = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$sql=rtrim(file_get_contents('sql/a14to_stat_'.$_REQUEST['by_who'].'1.sql'));
		$sql=stritr($sql,$params);
		$t1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$sql=rtrim(file_get_contents('sql/a14to_stat_'.$_REQUEST['by_who'].'2.sql'));
		$sql=stritr($sql,$params);
		$t2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

		foreach ($t as $k=>$v) {$d[$v['key']]['t']=$v;}
		foreach ($t1 as $k=>$v) {$d[$v['key']]['t1']=$v;}
		foreach ($t2 as $k=>$v) {$d[$v['key']]['t2']=$v;}


		isset($d)?$smarty->assign('d', $d):null;
		$sql=rtrim(file_get_contents('sql/a14to_stat_total.sql'));
		$sql=stritr($sql,$params);
//echo $sql;
		$t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('tt', $t);
		$sql=rtrim(file_get_contents('sql/a14to_stat_total1.sql'));
		$sql=stritr($sql,$params);
//echo $sql;
		$t1 = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('tt1', $t1);
		$sql=rtrim(file_get_contents('sql/a14to_stat_total2.sql'));
		$sql=stritr($sql,$params);
//echo $sql;
		$t2 = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('tt2', $t2);
	}
	$smarty->display('a14to_stat.html');
?>