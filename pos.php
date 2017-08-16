<?


if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("pos", array("pos_id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
                Table_Update("pos", array('pos_id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("pos", array("pos_name"=>$_REQUEST["new_pos_name"]), array("pos_name"=>$_REQUEST["new_pos_name"]));
}

$sql=rtrim(file_get_contents('sql/pos_list.sql'));
$pos = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos', $pos);
$smarty->display('pos.html');

?>