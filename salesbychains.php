<?php
	InitRequestVar("exp_list_without_ts",0);
	InitRequestVar("exp_list_only_ts",0);
	InitRequestVar("eta_list",$_SESSION["h_eta"]);
	InitRequestVar("sd",$_SESSION["month_list"]);
	InitRequestVar("ed",$_SESSION["month_list"]);
	InitRequestVar("rep_type",'brief');
	InitRequestVar("affiliation",'ter');
	InitRequestVar("salesbychainssort",'name');
	InitRequestVar("salesbychainsisrc",'all');
	InitRequestVar("chains",0);
	$params=array(
		':chains' => $_REQUEST["chains"],
		':dpt_id' => $_SESSION["dpt_id"],
		':tn'=>$tn,
		':eta_list' => "'".$_REQUEST["eta_list"]."'",
		':sd' => "'".$_REQUEST["sd"]."'",
		':ed' => "'".$_REQUEST["ed"]."'",
		':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
		':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
		':affiliation'=>"'".$_REQUEST['affiliation']."'",
		':salesbychainssort'=>"'".$_REQUEST['salesbychainssort']."'",
		':salesbychainsisrc'=>"'".$_REQUEST['salesbychainsisrc']."'",
	);
	$sql = rtrim(file_get_contents('sql/month_list.sql'));
	$sql=stritr($sql,$params);
	$dt = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('dt', $dt);
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
	$sql = rtrim(file_get_contents('sql/salesbychains_chain_list.sql'));
	$sql=stritr($sql,$params);
	$chains = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('chains', $chains);
	if (isset($_REQUEST['generate']))
	{
		$sql=rtrim(file_get_contents('sql/salesbychains.sql'));
		$sql1=rtrim(file_get_contents('sql/salesbychains1.sql'));
		$sql2=rtrim(file_get_contents('sql/salesbychains2.sql'));
		$sql=stritr($sql,$params);
		$sql1=stritr($sql1,$params);
		$sql2=stritr($sql2,$params);
		$b = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$b1 = $db->getAll($sql1, null, null, null, MDB2_FETCHMODE_ASSOC);
		$b2 = $db->getAll($sql2, null, null, null, MDB2_FETCHMODE_ASSOC);

		foreach ($b as $k=>$v){
			$x[$v["net_kod"]]=$v;
		}
		foreach ($b1 as $k=>$v){
			$x[$v["net_kod"]]["data"][$v["dt"]]=$v;
		}
		foreach ($b2 as $k=>$v){
			$x[$v["net_kod"]]["data"][$v["dt"]]["data"][$v["tp_kod"]]=$v;
		}
		isset($x)?$smarty->assign('d', $x):null;
		isset($x)?$_REQUEST["x"]=$x:null;
		//$_REQUEST["sql"]=$sql;
		//ses_req();
	}
	$smarty->display('salesbychains.html');
?>