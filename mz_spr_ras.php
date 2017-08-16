<?

audit("открыл mz_spr_ras","mz");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("mz_spr_ras", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_Update("mz_spr_ras", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("mz_spr_ras", array("name"=>$_REQUEST["new_name"]), array("name"=>$_REQUEST["new_name"]));
}

$sql=rtrim(file_get_contents('sql/mz_spr_ras.sql'));
$mz_spr_ras = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('mz_spr_ras', $mz_spr_ras);
$smarty->display('mz_spr_ras.html');

?>