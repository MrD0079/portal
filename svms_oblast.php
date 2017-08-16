<?
if (isset($_REQUEST["save"]))
{
	$table_name = 'svms_oblast';
	if (isset($_REQUEST["obl_add"]))
	{
		foreach ($_REQUEST["obl_add"] as $k=>$v)
		{
			$vals=array("tn"=>$_REQUEST["tn"],"oblast"=>$v);
			Table_Update($table_name, $vals, $vals);
		}
	}
	if (isset($_REQUEST["obl_del"]))
	{
		foreach ($_REQUEST["obl_del"] as $k=>$v)
		{
			$vals=array("tn"=>$_REQUEST["tn"],"oblast"=>$v);
			Table_Update($table_name, $vals,null);
		}
	}
}
if (isset($_REQUEST["tn"]))
{
	$sql=rtrim(file_get_contents('sql/svms_oblast_list.sql'));
	$p = array(':dpt_id' => $_SESSION["dpt_id"],':tn' => $_REQUEST["tn"]);
	$sql=stritr($sql,$p);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('oblast_list', $data);
	$fio_svms = $db->getOne('select fio from user_list where tn='.$_REQUEST["tn"]);
	$smarty->assign('fio_svms', $fio_svms);
	$sql=rtrim(file_get_contents('sql/svms_oblast.sql'));
	$p = array(':dpt_id' => $_SESSION["dpt_id"]);
	$sql=stritr($sql,$p);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('svms_oblast', $data);
}
$smarty->display('svms_oblast.html');
?>