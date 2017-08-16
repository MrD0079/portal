<?


if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("distr_activity", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
                Table_Update("distr_activity", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("distr_activity", array("name"=>$_REQUEST["new_name"],"dpt_id" => $_SESSION["dpt_id"]), array("name"=>$_REQUEST["new_name"],"dpt_id" => $_SESSION["dpt_id"]));
}

$sql=rtrim(file_get_contents('sql/distr_activity.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=stritr($sql,$p);
$distr_activity = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $distr_activity);
$smarty->display('distr_activity.html');

?>