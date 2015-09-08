<?php
if (isset($_REQUEST["save"]))
{
	$keys = array('tn'=>$_REQUEST["tn"]);
	$vals = array('test'=>1);
	Table_Update('p_plan', $keys,$vals);
}
else
{
	InitRequestVar("sd",$now);
	InitRequestVar("ed",$now);
	InitRequestVar("exp_list_without_ts",0);
	InitRequestVar("probs",0);
	$params=array(
		':tn' => $tn,
		':dpt_id' => $_SESSION["dpt_id"],
		':sd' => "'".$_REQUEST["sd"]."'",
		':ed' => "'".$_REQUEST["ed"]."'",
		':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
		':probs' => $_REQUEST["probs"],
	);
	$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
	$sql=stritr($sql,$params);
	$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('exp_list_without_ts', $exp_list_without_ts);
	$sql = rtrim(file_get_contents('sql/prob_test_report_probs.sql'));
	$sql=stritr($sql,$params);
	$probs = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('probs', $probs);
	if (isset($_REQUEST["generate"]))
	{
		$sql=rtrim(file_get_contents("sql/prob_test_report.sql"));
		$sql=stritr($sql,$params);
		$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		foreach ($d as $k => $v)
		{
			$p=array(':tn'=>$v['tn']);
			$sql=rtrim(file_get_contents('sql/prob_test_report_test_res.sql'));
			$sql=stritr($sql,$p);
			$test_res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			foreach ($test_res as $k2 => $v2)
			{
				isset($v2['id']) ? $d[$k]['test_res'][$v2['id']]=$v2 : null;
			}
		}
		$smarty->assign("d", $d);
	}
	$smarty->display('prob_test_report.html');
}
?>