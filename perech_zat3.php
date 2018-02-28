<?


if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("perech_zat3", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
                Table_Update("perech_zat3", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("perech_zat3", array("name"=>$_REQUEST["new_name"]), array("name"=>$_REQUEST["new_name"]));
}

$sql=rtrim(file_get_contents('sql/perech_zat3.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $res);
$smarty->display('perech_zat3.html');

?>