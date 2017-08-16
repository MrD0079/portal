<?

audit("открыл mz_spr_inv","mz");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("mz_spr_inv", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_Update("mz_spr_inv", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("mz_spr_inv", array("name"=>$_REQUEST["new_name"]), array("name"=>$_REQUEST["new_name"]));
}

$sql=rtrim(file_get_contents('sql/mz_spr_inv.sql'));
$mz_spr_inv = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('mz_spr_inv', $mz_spr_inv);
$smarty->display('mz_spr_inv.html');

?>