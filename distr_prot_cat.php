<?


if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("distr_prot_cat", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("distr_prot_cat", null, MDB2_AUTOQUERY_DELETE, "id=".$k);
	}
}

if (isset($_REQUEST["new"]))
{
	$affectedRows = $db->extended->autoExecute("distr_prot_cat", array("name"=>$_REQUEST["new_distr_prot_cat_name"],"dpt_id" => $_SESSION["dpt_id"]), MDB2_AUTOQUERY_INSERT);
}

$sql=rtrim(file_get_contents('sql/distr_prot_cat.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=stritr($sql,$p);
$distr_prot_cat = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('distr_prot_cat', $distr_prot_cat);
$smarty->display('distr_prot_cat.html');

?>