<?


//ses_req();


audit("открыл departments","departments");

$sql=rtrim(file_get_contents('sql/currencies.sql'));
$currencies = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('currencies', $currencies);



if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("departments", array("dpt_id"=>$k),$v);
		if (!file_exists("files/".$v["cnt_kod"])) {mkdir("files/".$v["cnt_kod"],0777,true);}
	}
}



if (isset($_REQUEST["del"])&&isset($_REQUEST["delete"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("departments", null, MDB2_AUTOQUERY_DELETE, "dpt_id=".$k);
	}
}

if (isset($_REQUEST["add"]))
{
	$affectedRows = $db->extended->autoExecute("departments", $_REQUEST["new"], MDB2_AUTOQUERY_INSERT);
	if (!file_exists("files/".$_REQUEST["new"]["cnt_kod"])) {mkdir("files/".$_REQUEST["new"]["cnt_kod"],0777,true);}
}

$sql=rtrim(file_get_contents('sql/departments.sql'));
$departments = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('departments', $departments);

$smarty->display('departments.html');

?>