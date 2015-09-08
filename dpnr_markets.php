<?
if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("dpnr_markets", array("id"=>$k),$v);
	}
}
if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("dpnr_markets", null, MDB2_AUTOQUERY_DELETE, "id=".$k);
	}
}
if (isset($_REQUEST["new"]))
{
	$affectedRows = $db->extended->autoExecute("dpnr_markets", array("name"=>$_REQUEST["new_name"]), MDB2_AUTOQUERY_INSERT);
}
$sql=rtrim(file_get_contents('sql/dpnr_markets.sql'));
$markets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $markets);
$smarty->display('dpnr_markets.html');
?>