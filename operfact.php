<?
audit("открыл operfact","fin_plan");
InitRequestVar("nets",0);
InitRequestVar("calendar_years");
InitRequestVar("calendar_months");
InitRequestVar("tn_rmkk",0);
InitRequestVar("tn_mkk",0);
InitRequestVar("mgroups",1);
InitRequestVar("reptype",1);
if (isset($_REQUEST["calendar_years"])&&isset($_REQUEST["generate"]))
{
	$sql=rtrim(file_get_contents('sql/operfact.sql'));
	$sqlnet=rtrim(file_get_contents('sql/operfactnet.sql'));
	$sqltotal=rtrim(file_get_contents('sql/operfacttotal.sql'));
	$params=array(
		':dpt_id' => $_SESSION["dpt_id"],
		':y'=>$_REQUEST["calendar_years"],
		':nets'=>$_REQUEST["nets"],
		':calendar_months'=>$_REQUEST["calendar_months"],
		':mgroups'=>$_REQUEST["mgroups"],
		':reptype'=>$_REQUEST["reptype"],
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':tn'=>$tn,
	);
	$sql=stritr($sql,$params);
	$sqlnet=stritr($sqlnet,$params);
	$sqltotal=stritr($sqltotal,$params);
	//echo $sql;
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$datanet = $db->getAll($sqlnet, null, null, null, MDB2_FETCHMODE_ASSOC);
	$datatotal = $db->getRow($sqltotal, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($data as $k=>$v)
	{
		$d[$v["id_net"]]["data"][$v["payment_format"]]=$v;
	}
	foreach ($datanet as $k=>$v)
	{
		$d[$v["id_net"]]["head"]=$v;
	}
	//print_r($data);
	//print_r($d);
	isset($d)?$smarty->assign('finreport', $d) : null;
	$smarty->assign('finreporttotal', $datatotal);
}
$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);
$sql=rtrim(file_get_contents('sql/calendar_months.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_months', $data);
$sql=rtrim(file_get_contents('sql/nets.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);
$sql=rtrim(file_get_contents('sql/list_rmkk.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$list_rmkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_rmkk', $list_rmkk);
$sql=rtrim(file_get_contents('sql/list_mkk.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$list_mkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk', $list_mkk);
$smarty->display('kk_start.html');
$smarty->display('operfact.html');
$smarty->display('kk_end.html');
?>