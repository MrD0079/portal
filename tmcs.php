<?


if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("tmcs", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_Update("tmcs", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("tmcs", array("name"=>$_REQUEST["new_tmc_name"]),array("name"=>$_REQUEST["new_tmc_name"]));
}

$sql=rtrim(file_get_contents('sql/tmcs.sql'));
$tmcs = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tmcs', $tmcs);
$smarty->display('tmcs.html');

?>