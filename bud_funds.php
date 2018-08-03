<?





audit("открыл bud_funds","bud");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("bud_funds", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
                Table_Update("bud_funds", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("bud_funds", array("name"=>$_REQUEST["new_name"],"dpt_id" => $_SESSION["dpt_id"]), array("name"=>$_REQUEST["new_name"],"dpt_id" => $_SESSION["dpt_id"]));
}

$p = array(":dpt_id" => $_SESSION["dpt_id"]);

$sql=rtrim(file_get_contents('sql/bud_funds.sql'));
$sql=stritr($sql,$p);
$bud_funds = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_funds', $bud_funds);

$sql=rtrim(file_get_contents('sql/bud_funds_norm_log.sql'));
$sql=stritr($sql,$p);
$bud_funds_norm_log = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_funds_norm_log', $bud_funds_norm_log);

$smarty->display('bud_funds.html');

?>