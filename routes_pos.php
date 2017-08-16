<?

audit("открыл routes_pos","routes");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("routes_pos", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_Update("routes_pos", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("routes_pos", array("name"=>$_REQUEST["new_agent_name"]), array("name"=>$_REQUEST["new_agent_name"]));
}

$sql=rtrim(file_get_contents('sql/routes_pos.sql'));
$routes_pos = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_pos', $routes_pos);
$smarty->display('routes_pos.html');

?>