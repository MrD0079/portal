<?


if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		$v["dog_start"]=OraDate2MDBDate($v["dog_start"]);
		$v["dog_end"]=OraDate2MDBDate($v["dog_end"]);
		Table_Update("urlic", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_Update("urlic", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("urlic", array("name"=>$_REQUEST["new_name"]), array("name"=>$_REQUEST["new_name"]));
}

$sql=rtrim(file_get_contents('sql/urlic.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $res);



$smarty->display('kk_start.html');
$smarty->display('urlic.html');
$smarty->display('kk_end.html');

?>