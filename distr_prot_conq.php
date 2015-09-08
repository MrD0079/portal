<?

if (isset($_REQUEST["new"]))
{
	$affectedRows = $db->extended->autoExecute(
		"distr_prot_conq",
		array
		(
			"name"=>$_REQUEST["new_distr_prot_conq_name"],"dpt_id" => $_SESSION["dpt_id"]
		),
		MDB2_AUTOQUERY_INSERT
	);
}

$sql=rtrim(file_get_contents('sql/distr_prot_conq.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=stritr($sql,$p);
$distr_prot_conq = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('distr_prot_conq', $distr_prot_conq);
$smarty->display('distr_prot_conq.html');

?>