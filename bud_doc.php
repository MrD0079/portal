<?





audit("открыл bud_doc","bud");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("bud_doc", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_Update("bud_doc", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("bud_doc", array("name"=>$_REQUEST["new_name"],"dpt_id" => $_SESSION["dpt_id"]),array("name"=>$_REQUEST["new_name"],"dpt_id" => $_SESSION["dpt_id"]));
}

$sql=rtrim(file_get_contents('sql/bud_doc.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$bud_doc = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_doc', $bud_doc);
$smarty->display('bud_doc.html');

?>