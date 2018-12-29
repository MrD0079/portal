<?php

	InitRequestVar("exp_list_without_ts",0);
	InitRequestVar("exp_list_only_ts",0);
	InitRequestVar("eta_list",$_SESSION["h_eta"]);
	InitRequestVar("sd",$now);
	InitRequestVar("ed",$now);
	InitRequestVar("by_who",'eta');
	//InitRequestVar("rep_type",'brief');
	InitRequestVar("rep_type",'detailed');
	$params=array(
		':dpt_id' => $_SESSION["dpt_id"],
		':tn'=>$tn,
		':eta_list' => "'".$_REQUEST["eta_list"]."'",
		':sd' => "'".$_REQUEST["sd"]."'",
		':ed' => "'".$_REQUEST["ed"]."'",
		':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
		':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
		':by_who'=>"'".$_REQUEST['by_who']."'",
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
	if (isset($_REQUEST['generate']))
	{
		if ($_REQUEST["rep_type"]=="brief")
		{
			$sql=rtrim(file_get_contents('sql/standSHst_'.$_REQUEST['by_who'].'.sql'));
			$sql=stritr($sql,$params);
			$t = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
                        $smarty->assign('d', $t);
		}
		else
		{
			$sql=rtrim(file_get_contents('sql/standSHst_detailed.sql'));
			$sql=stritr($sql,$params);
			$t = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$smarty->assign('d', $t);
		}
		$sql=rtrim(file_get_contents('sql/standSHst_total.sql'));
		$sql=stritr($sql,$params);
		$t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('tt', $t);
	}
	$smarty->display('standSHst.html');
?>