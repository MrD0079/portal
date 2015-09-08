<?php
//audit("вошел в список сетей");
//ses_req();
if (isset($_REQUEST["save"]))
{
	$table_name = "magic_tp_select";
	if (isset($_REQUEST["ok_traid_changed"]))
	{
		foreach ($_REQUEST["ok_traid_changed"] as $key => $val)
		{
			if ($val!=null)
			{
				$keys = array('KOD_TP'=>$key);
				$values = array('ok_traid'=>Bool2Int($val));
				Table_Update ($table_name, $keys, $values);
			}
		}
	}
}


if (isset($_REQUEST["exp_list_without_ts"])){$_SESSION["exp_list_without_ts"]=$_REQUEST["exp_list_without_ts"];}else{if (isset($_SESSION["exp_list_without_ts"])){$_REQUEST["exp_list_without_ts"]=$_SESSION["exp_list_without_ts"];}}
if (isset($_REQUEST["exp_list_only_ts"])){$_SESSION["exp_list_only_ts"]=$_REQUEST["exp_list_only_ts"];}else{if (isset($_SESSION["exp_list_only_ts"])){$_REQUEST["exp_list_only_ts"]=$_SESSION["exp_list_only_ts"];}}
//if (isset($_REQUEST["giveup"])){$_SESSION["giveup"]=$_REQUEST["giveup"];}else{if (isset($_SESSION["giveup"])){$_REQUEST["giveup"]=$_SESSION["giveup"];}}
//if (isset($_REQUEST["giveup_check"])){$_SESSION["giveup_check"]=$_REQUEST["giveup_check"];}else{if (isset($_SESSION["giveup_check"])){$_REQUEST["giveup_check"]=$_SESSION["giveup_check"];}}
!isset($_REQUEST["exp_list_without_ts"]) ? $_REQUEST["exp_list_without_ts"]=0: null;
!isset($_REQUEST["exp_list_only_ts"]) ? $_REQUEST["exp_list_only_ts"]=0: null;
!isset($_REQUEST["giveup"]) ? $_REQUEST["giveup"]=0: null;
!isset($_REQUEST["giveup_check"]) ? $_REQUEST["giveup_check"]=0: null;
$_SESSION["exp_list_without_ts"]=$_REQUEST["exp_list_without_ts"];
$_SESSION["exp_list_only_ts"]=$_REQUEST["exp_list_only_ts"];
//$_SESSION["giveup"]=$_REQUEST["giveup"];
//$_SESSION["giveup_check"]=$_REQUEST["giveup_check"];

	$params=array(':dpt_id' => $_SESSION["dpt_id"],
		':tn'=>$tn,
		':giveup' => $_REQUEST["giveup"],
		':giveup_check' => $_REQUEST["giveup_check"],
		':dpt_id' => $_SESSION["dpt_id"],
		':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
		':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"]
	);


$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
$sql=stritr($sql,$params);
//echo $sql;
//$exp_list = &$db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_only_ts', $exp_list_only_ts);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
//echo $sql;
//$exp_list = &$db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);



$sql=rtrim(file_get_contents('sql/magic_report.sql'));
//echo $sql;
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($tp);
$smarty->assign('tp', $tp);


$sql_total=rtrim(file_get_contents('sql/magic_report_total.sql'));
//echo $sql_total;
$sql_total=stritr($sql_total,$params);
$tp_total = $db->getAll($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp_total', $tp_total);


$smarty->display('magic_report.html');
?>