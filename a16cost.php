<?php
//ses_req();
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
			$sql=rtrim(file_get_contents('sql/a16cost_'.$_REQUEST['by_who'].'.sql'));
			$sql=stritr($sql,$params);
			$t = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$sql=rtrim(file_get_contents('sql/a16cost_'.$_REQUEST['by_who'].'1.sql'));
			$sql=stritr($sql,$params);
			$t1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$sql=rtrim(file_get_contents('sql/a16cost_'.$_REQUEST['by_who'].'2.sql'));
			$sql=stritr($sql,$params);
			$t2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$sql=rtrim(file_get_contents('sql/a16cost_'.$_REQUEST['by_who'].'3.sql'));
			$sql=stritr($sql,$params);
			$t3 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			foreach ($t as $k=>$v) {$d[$v['key']]['t']=$v;}
			foreach ($t1 as $k=>$v) {$d[$v['key']]['t1']=$v;}
			foreach ($t2 as $k=>$v) {$d[$v['key']]['t2']=$v;}
			foreach ($t3 as $k=>$v) {$d[$v['key']]['t3']=$v;}
			isset($d)?$smarty->assign('d', $d):null;
		}
		else
		{
			$sql=rtrim(file_get_contents('sql/a16cost_detailed.sql'));
			$sql=stritr($sql,$params);
			$t = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$smarty->assign('d', $t);
		}
		/*$sql=rtrim(file_get_contents('sql/a16cost_total.sql'));
		$sql=stritr($sql,$params);
		$t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('tt', $t);
		$sql=rtrim(file_get_contents('sql/a16cost_total1.sql'));
		$sql=stritr($sql,$params);
		$t1 = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('tt1', $t1);
		$sql=rtrim(file_get_contents('sql/a16cost_total2.sql'));
		$sql=stritr($sql,$params);
		$t2 = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('tt2', $t2);
		$sql=rtrim(file_get_contents('sql/a16cost_total3.sql'));
		$sql=stritr($sql,$params);
		$t3 = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('tt3', $t3);*/
	}
	$smarty->display('a16cost.html');
?>