<?

audit ("открыл форму категорий СЗ","sz");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("sz_cat", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_Update("sz_cat", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("sz_cat", array("name"=>$_REQUEST["new_sz_cat_name"]), array("name"=>$_REQUEST["new_sz_cat_name"]));
}

$sql=rtrim(file_get_contents('sql/sz_cat.sql'));
$sz_cat = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('sz_cat', $sz_cat);
$smarty->display('sz_cat.html');

?>