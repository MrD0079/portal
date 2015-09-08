<?
if (isset($_REQUEST["save"]))
{
	$table_name = 'mkk_oblast';
	if (isset($_REQUEST["obl_add"]))
	{
		foreach ($_REQUEST["obl_add"] as $k=>$v)
		{
			$vals=array("tn"=>$_REQUEST["tn"],"oblast"=>$v);
			$affectedRows = $db->extended->autoExecute($table_name, $vals, MDB2_AUTOQUERY_INSERT);
		}
	}
	if (isset($_REQUEST["obl_del"]))
	{
		foreach ($_REQUEST["obl_del"] as $k=>$v)
		{
			$vals=array("tn"=>$_REQUEST["tn"],"oblast"=>$v);
			$affectedRows = $db->extended->autoExecute($table_name, null, MDB2_AUTOQUERY_DELETE, "oblast='".$v."' and tn=".$_REQUEST["tn"]);
		}
	}
}
if (isset($_REQUEST["tn"]))
{
	$sql=rtrim(file_get_contents('sql/mkk_oblast_list.sql'));
	$p = array(':dpt_id' => $_SESSION["dpt_id"],':tn' => $_REQUEST["tn"]);
	$sql=stritr($sql,$p);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('oblast_list', $data);
	$fio_mkk = $db->getOne('select fio from user_list where tn='.$_REQUEST["tn"]);
	$smarty->assign('fio_mkk', $fio_mkk);
	$sql=rtrim(file_get_contents('sql/mkk_oblast.sql'));
	$p = array(':dpt_id' => $_SESSION["dpt_id"]);
	$sql=stritr($sql,$p);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('mkk_oblast', $data);
}
$smarty->display('mkk_oblast.html');
?>