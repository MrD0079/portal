<?


//ses_req();


audit("открыл tr_loc","bud");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("tr_loc", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("tr_loc", null, MDB2_AUTOQUERY_DELETE, "id=".$k);
	}
}

if (isset($_REQUEST["new"]))
{
	$affectedRows = $db->extended->autoExecute("tr_loc", array("name"=>$_REQUEST["new_name"],"addr"=>$_REQUEST["new_addr"],"text" => $_REQUEST["new_text"],"url" => $_REQUEST["new_url"]), MDB2_AUTOQUERY_INSERT);
}

$sql=rtrim(file_get_contents('sql/tr_loc.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$tr_loc = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr_loc', $tr_loc);
$smarty->display('tr_loc.html');

?>