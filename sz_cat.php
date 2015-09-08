<?

audit ("открыл форму категорий СЗ","sz");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("sz_cat", array("id"=>$k),$v);
		audit ("сохранил категорию СЗ ".$k." ".$v["name"],"sz");
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("sz_cat", null, MDB2_AUTOQUERY_DELETE, "id=".$k);
		audit ("удалил категорию СЗ ".$k,"sz");
	}
}

if (isset($_REQUEST["new"]))
{
	$affectedRows = $db->extended->autoExecute("sz_cat", array("name"=>$_REQUEST["new_sz_cat_name"]), MDB2_AUTOQUERY_INSERT);
	audit ("добавил категорию СЗ ".$_REQUEST["new_sz_cat_name"],"sz");
}

$sql=rtrim(file_get_contents('sql/sz_cat.sql'));
$sz_cat = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('sz_cat', $sz_cat);
$smarty->display('sz_cat.html');

?>