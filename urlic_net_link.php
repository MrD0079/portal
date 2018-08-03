<?



if (isset($_REQUEST["save"]))
{
	$table_name = 'urlic_net';
	if (isset($_REQUEST["urlic_add"]))
	{
		foreach ($_REQUEST["urlic_add"] as $k=>$v)
		{
			$vals=array("id_net"=>$_REQUEST["id_net"],"urlic"=>$v);
			Table_Update($table_name, $vals, $vals);
		}
	}
	if (isset($_REQUEST["urlic_del"]))
	{
		foreach ($_REQUEST["urlic_del"] as $k=>$v)
		{
			$vals=array("id_net"=>$_REQUEST["id_net"],"urlic"=>$v);
			Table_Update($table_name, $vals,null);
		}
	}
}






if (isset($_REQUEST["id_net"]))
{
$sql=rtrim(file_get_contents('sql/urlic_net_list.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"],':id_net' => $_REQUEST["id_net"]);
$sql=stritr($sql,$p);
//echo $sql;
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('urlic_net_list', $data);

$id_net = $db->getOne('select net_name from nets where id_net='.$_REQUEST["id_net"]);
$smarty->assign('id_net', $id_net);
}



$smarty->display('kk_start.html');
$smarty->display('urlic_net_link.html');
$smarty->display('kk_end.html');




?>