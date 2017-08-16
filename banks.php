<?

//print_r($_SESSION);

//ses_req();

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("banks", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
                Table_Update("banks", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("banks", array("name"=>$_REQUEST["new_bank_name"]),array("name"=>$_REQUEST["new_bank_name"]));
}

$sql=rtrim(file_get_contents('sql/banks.sql'));
$banks = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('banks', $banks);
$smarty->display('banks.html');

?>