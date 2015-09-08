<?
if (isset($_REQUEST["save"]))
{
	$table_name = 'routes_logins_nets';
	if (isset($_REQUEST["obl_add"]))
	{
		foreach ($_REQUEST["obl_add"] as $k=>$v)
		{
			$vals=array("login"=>$_REQUEST["login"],"id_net"=>$v);
			$affectedRows = $db->extended->autoExecute($table_name, $vals, MDB2_AUTOQUERY_INSERT);
		}
	}
	if (isset($_REQUEST["obl_del"]))
	{
		foreach ($_REQUEST["obl_del"] as $k=>$v)
		{
			$vals=array("login"=>$_REQUEST["login"],"id_net"=>$v);
			$affectedRows = $db->extended->autoExecute($table_name, null, MDB2_AUTOQUERY_DELETE, "id_net='".$v."' and login='".$_REQUEST["login"]."'");
		}
	}
}
if (isset($_REQUEST["login"]))
{
$sql=rtrim(file_get_contents('sql/routes_logins_nets_list.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"],':login' => "'".$_REQUEST["login"]."'");
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets_list', $data);
$sql=rtrim(file_get_contents('sql/routes_logins_nets.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_logins_nets', $data);
$sql=rtrim(file_get_contents('sql/routes_logins_get_login_info.sql'));
$p = array(':login' => "'".$_REQUEST["login"]."'");
$sql=stritr($sql,$p);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('login_info', $data);
}
$smarty->display('routes_logins_nets.html');
?>