<?php

if (isset($_REQUEST["save"]))
{
	$_REQUEST['generate']=1;
	if (isset($_REQUEST["data"]))
	{
		foreach ($_REQUEST["data"] as $key => $val)
		{
			$dt=$db->getOne("SELECT TO_CHAR (TRUNC (TO_DATE ('".$_REQUEST['sd']."', 'dd.mm.yyyy'), 'mm'),'dd.mm.yyyy') FROM DUAL");
			$keys = array('tp_kod_key'=>$key,'dt'=>OraDate2MDBDate($dt));
			$values=null;
			if (isset($val['zst']))
			{
				if ($val['zst']==1)
				{
					$values=array();
					$values['lu_fio']=$fio;
				}
			}
			if (isset($val['comm']))
			{
				$values['comm']=$val['comm'];
			}
			Table_Update ('a18tozst', $keys, $values);
		}
	}
}

	InitRequestVar("exp_list_without_ts",0);
	InitRequestVar("exp_list_only_ts",0);
	InitRequestVar("region_list");
	InitRequestVar("eta_list",$_SESSION["h_eta"]);
	InitRequestVar("sd",$now);
	InitRequestVar("ed",$now);
	/*InitRequestVar("ok_ts",1);
	InitRequestVar("ok_auditor",1);
	InitRequestVar("st_ts",1);
	InitRequestVar("st_auditor",1);*/
	InitRequestVar("by_who",'eta');
	InitRequestVar("rep_type",'brief');
	InitRequestVar("ok_st_tm",1);
	InitRequestVar("zst",1);
	$params=array(
		':dpt_id' => $_SESSION["dpt_id"],
		':tn'=>$tn,
		/*':ok_ts' => $_REQUEST["ok_ts"],
		':ok_auditor' => $_REQUEST["ok_auditor"],
		':st_ts' => $_REQUEST["st_ts"],
		':st_auditor' => $_REQUEST["st_auditor"],*/
		':eta_list' => "'".$_REQUEST["eta_list"]."'",
		':region_list' => "'".$_REQUEST["region_list"]."'",
		':sd' => "'".$_REQUEST["sd"]."'",
		':ed' => "'".$_REQUEST["ed"]."'",
		':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
		':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
		':by_who'=>"'".$_REQUEST['by_who']."'",
		':ok_st_tm' => $_REQUEST["ok_st_tm"],
		':zst' => $_REQUEST["zst"],
	);
	$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
	$sql=stritr($sql,$params);
	$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('exp_list_only_ts', $exp_list_only_ts);
	$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
	$sql=stritr($sql,$params);
	$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('exp_list_without_ts', $exp_list_without_ts);
	$sql = rtrim(file_get_contents('sql/a18to_eta_list.sql'));
	$sql=stritr($sql,$params);
	$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('eta_list', $eta_list);
	if (isset($_REQUEST['generate']))
	{
                $params[':brief']=rtrim(file_get_contents('sql/a18to_stat_brief.sql'));
		if ($_REQUEST["rep_type"]=="brief")
		{
			$sql=rtrim(file_get_contents('sql/a18to_stat_'.$_REQUEST['by_who'].'.sql'));
			$sql=stritr($sql,$params);
			$sql=stritr($sql,$params);
			$t = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$sql=rtrim(file_get_contents('sql/a18to_stat_'.$_REQUEST['by_who'].'1.sql'));
			$sql=stritr($sql,$params);
                        $sql=stritr($sql,$params);
			$t1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$sql=rtrim(file_get_contents('sql/a18to_stat_'.$_REQUEST['by_who'].'2.sql'));
			$sql=stritr($sql,$params);
                        $sql=stritr($sql,$params);
			$t2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$sql=rtrim(file_get_contents('sql/a18to_stat_'.$_REQUEST['by_who'].'3.sql'));
			$sql=stritr($sql,$params);
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
			$sql=rtrim(file_get_contents('sql/a18to_stat_detailed.sql'));
			$sql=stritr($sql,$params);
			$sql=stritr($sql,$params);
                        //echo $sql;
			$t = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
                        //print_r($t);
			$smarty->assign('d', $t);
		}
		$sql=rtrim(file_get_contents('sql/a18to_stat_total.sql'));
		$sql=stritr($sql,$params);
                $sql=stritr($sql,$params);
		$t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('tt', $t);
		$sql=rtrim(file_get_contents('sql/a18to_stat_total1.sql'));
		$sql=stritr($sql,$params);
                $sql=stritr($sql,$params);
		$t1 = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('tt1', $t1);
		$sql=rtrim(file_get_contents('sql/a18to_stat_total2.sql'));
		$sql=stritr($sql,$params);
                $sql=stritr($sql,$params);
		$t2 = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('tt2', $t2);
		$sql=rtrim(file_get_contents('sql/a18to_stat_total3.sql'));
                $sql=stritr($sql,$params);
		$sql=stritr($sql,$params);
		$t3 = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('tt3', $t3);
	}
	$smarty->display('a18to_stat.html');
?>