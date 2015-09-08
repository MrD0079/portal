<?

audit("открыл azl_city","azl");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("azl_city", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("azl_city", null, MDB2_AUTOQUERY_DELETE, "id=".$k);
	}
}

if (isset($_REQUEST["new"]))
{
	$affectedRows = $db->extended->autoExecute("azl_city", array("name"=>$_REQUEST["new_name"]), MDB2_AUTOQUERY_INSERT);
}

$sql=rtrim(file_get_contents('sql/azl_city.sql'));
$azl_city = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('azl_city', $azl_city);
$smarty->display('azl_city.html');

?>