<?
if (isset($_REQUEST["save"]))
{
	$table_name = 'routes_logins_oblast';
	if (isset($_REQUEST["obl_add"]))
	{
		foreach ($_REQUEST["obl_add"] as $k=>$v)
		{
			$vals=array("login"=>$_REQUEST["login"],"oblast"=>$v);
			$affectedRows = $db->extended->autoExecute($table_name, $vals, MDB2_AUTOQUERY_INSERT);
		}
	}
	if (isset($_REQUEST["obl_del"]))
	{
		foreach ($_REQUEST["obl_del"] as $k=>$v)
		{
			$vals=array("login"=>$_REQUEST["login"],"oblast"=>$v);
			$affectedRows = $db->extended->autoExecute($table_name, null, MDB2_AUTOQUERY_DELETE, "oblast='".$v."' and login='".$_REQUEST["login"]."'");
		}
	}
}
if (isset($_REQUEST["login"]))
{
$sql=rtrim(file_get_contents('sql/routes_logins_oblast_list.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"],':login' => "'".$_REQUEST["login"]."'");
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('oblast_list', $data);
$sql=rtrim(file_get_contents('sql/routes_logins_oblast.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_logins_oblast', $data);
$sql=rtrim(file_get_contents('sql/routes_logins_get_login_info.sql'));
$p = array(':login' => "'".$_REQUEST["login"]."'");
$sql=stritr($sql,$p);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('login_info', $data);
}
$smarty->display('routes_logins_oblast.html');
?>