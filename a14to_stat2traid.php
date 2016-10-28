<?php
InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("sd",$_REQUEST["month_list"]);
InitRequestVar("ed",$_REQUEST["month_list"]);
InitRequestVar("standart",1);
$params=array(
	':dpt_id' => $_SESSION["dpt_id"],
	':tn'=>$tn,
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
	':sd' => "'".$_REQUEST["sd"]."'",
	':ed' => "'".$_REQUEST["ed"]."'",
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
	':standart' => $_REQUEST["standart"],
);
if (isset($_REQUEST["detail"]))
{
	$params[":sttype"]="'".$_REQUEST["sttype"]."'";
	$sql=rtrim(file_get_contents('sql/a14to_stat2traid_detail.sql'));
	$sql=stritr($sql,$params);
	//echo $sql;
	$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('d', $d);
	//print_r($d);
	$smarty->display('a14to_stat2traid_detail.html');
}
else
{
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
	$sql = rtrim(file_get_contents('sql/month_list.sql'));
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('month_list', $res);
	if (isset($_REQUEST['generate']))
	{
		$sql="SELECT c.*, TO_CHAR (c.data, 'dd.mm.yyyy') cdt FROM calendar c WHERE data = TRUNC (data, 'mm') AND data BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy') AND TO_DATE ( :ed, 'dd.mm.yyyy') ORDER BY data";
		$sql=stritr($sql,$params);
		$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		foreach ($d as $k=>$v)
		{
			$params[":ed"]="'".$v["cdt"]."'";
			$sql=rtrim(file_get_contents('sql/a14to_stat2traid.sql'));
			$sql=stritr($sql,$params);
			$t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$d[$k]["data"]=$t;
		}
		isset($d)?$smarty->assign('d', $d):null;
	}
	$smarty->display('a14to_stat2traid.html');
}
?>