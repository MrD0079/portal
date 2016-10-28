<?
audit("открыл doc_debit","fin_plan");
InitRequestVar("nets",0);
InitRequestVar("y");
InitRequestVar("m");
InitRequestVar("tn_rmkk",0);
InitRequestVar("tn_mkk",0);
InitRequestVar("mgroups",1);
InitRequestVar("payment_type",0);
InitRequestVar("payer",0);
if (isset($_REQUEST["y"])&&isset($_REQUEST["generate"]))
{
	$sql=rtrim(file_get_contents('sql/doc_debit.sql'));
	$params=array(
		':mgroups'=>$_REQUEST["mgroups"],
		':dpt_id' => $_SESSION["dpt_id"],
		':y'=>$_REQUEST["y"],
		':nets'=>$_REQUEST["nets"],
		':m'=>$_REQUEST["m"],
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':tn'=>$tn,
		':payment_type'=>$_REQUEST["payment_type"],
		':payer'=>$_REQUEST["payer"],
	);
	$sql=stritr($sql,$params);
	//echo $sql;
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($data as $k=>$v)
	{
		$d[$v["id_net"]]["head"]=$v;
		$d[$v["id_net"]]["data"][$v["fil_id"]]=$v;
	}
	//print_r($data);
	//print_r($d);
	isset($d)?$smarty->assign('finreport', $d) : null;
}
$sql=rtrim(file_get_contents('sql/payment_type.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('payment_type', $data);
$sql=rtrim(file_get_contents('sql/distr_prot_di_kk.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('payer', $data);
$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('y', $data);
$sql=rtrim(file_get_contents('sql/calendar_months.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('m', $data);
$sql=rtrim(file_get_contents('sql/nets.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);
$sql=rtrim(file_get_contents('sql/list_rmkk.sql'));
$sql=stritr($sql,$params);
$list_rmkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_rmkk', $list_rmkk);
$sql=rtrim(file_get_contents('sql/list_mkk.sql'));
$sql=stritr($sql,$params);
$list_mkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk', $list_mkk);
$smarty->display('doc_debit.html');
?>