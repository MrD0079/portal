<?

//print_r($_SESSION);

//ses_req();

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("currencies", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
                Table_Update("currencies", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("currencies", array("name"=>$_REQUEST["new_name"]), array("name"=>$_REQUEST["new_name"]));
}

$sql=rtrim(file_get_contents('sql/currencies.sql'));
$currencies = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('currencies', $currencies);
$smarty->display('currencies.html');

?>