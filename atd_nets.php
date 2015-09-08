<?

audit("открыл atd_nets","atd");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("atd_nets", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("atd_nets", null, MDB2_AUTOQUERY_DELETE, "id=".$k);
	}
}

if (isset($_REQUEST["new"]))
{
	$affectedRows = $db->extended->autoExecute("atd_nets", array("name"=>$_REQUEST["new_name"],"kod"=>$_REQUEST["new_kod"],"graph"=>$_REQUEST["new_graph"]), MDB2_AUTOQUERY_INSERT);
}

$sql=rtrim(file_get_contents('sql/atd_nets.sql'));
$atd_nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('atd_nets', $atd_nets);
$smarty->display('atd_nets.html');

?>