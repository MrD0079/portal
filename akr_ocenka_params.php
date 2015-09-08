<?

audit("открыл akr_ocenka_params","akr");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("akr_ocenka_params", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("akr_ocenka_params", null, MDB2_AUTOQUERY_DELETE, "id=".$k);
	}
}

if (isset($_REQUEST["new"]))
{
	$affectedRows = $db->extended->autoExecute("akr_ocenka_params", array("name"=>$_REQUEST["new_name"]), MDB2_AUTOQUERY_INSERT);
}

$sql=rtrim(file_get_contents('sql/akr_ocenka_params.sql'));
$akr_ocenka_params = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('akr_ocenka_params', $akr_ocenka_params);
$smarty->display('akr_ocenka_params.html');

?>