<?

//print_r($_SESSION);

//ses_req();

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("ol_gr", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("ol_gr", null, MDB2_AUTOQUERY_DELETE, "id=".$k);
	}
}

if (isset($_REQUEST["new"]))
{
	$affectedRows = $db->extended->autoExecute("ol_gr", array("name"=>$_REQUEST["new_gr_name"],'dpt_id' => $_SESSION["dpt_id"]), MDB2_AUTOQUERY_INSERT);
}

$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=rtrim(file_get_contents('sql/ol_gr.sql'));
$sql=stritr($sql,$p);
$ol_gr = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ol_gr', $ol_gr);
$smarty->display('ol_gr.html');

?>