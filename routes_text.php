<?

audit("открыл routes_text","routes");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("routes_text", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_Update("routes_text", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("routes_text", array("name"=>$_REQUEST["new_text_name"]), array("name"=>$_REQUEST["new_text_name"]));
}

$sql=rtrim(file_get_contents('sql/routes_text.sql'));
$routes_text = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_text', $routes_text);
$smarty->display('routes_text.html');

?>