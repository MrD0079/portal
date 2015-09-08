<?

audit("открыл akr_nets","akr");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("akr_nets", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("akr_nets", null, MDB2_AUTOQUERY_DELETE, "id=".$k);
	}
}

if (isset($_REQUEST["new"]))
{
	$affectedRows = $db->extended->autoExecute("akr_nets", array("name"=>$_REQUEST["new_name"],"kod"=>$_REQUEST["new_kod"],"graph"=>$_REQUEST["new_graph"]), MDB2_AUTOQUERY_INSERT);
}

$sql=rtrim(file_get_contents('sql/akr_nets.sql'));
$akr_nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('akr_nets', $akr_nets);
$smarty->display('akr_nets.html');

?>