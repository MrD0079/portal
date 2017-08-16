<?


if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("lang", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_Update("lang", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("lang", array("name"=>$_REQUEST["new_name"]), array("name"=>$_REQUEST["new_name"]));
}

$sql=rtrim(file_get_contents('sql/lang.sql'));
$lang = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $lang);
$smarty->display('lang.html');

?>