<?


audit ("открыл форму шаблонов СЗ","sz");


if (isset($_REQUEST["add"]))
{
	Table_update("sz_tpl",array("dpt_id"=>$_SESSION["dpt_id"],"id"=>0),array("text"=>addslashes($_REQUEST["text"]),"head"=>addslashes($_REQUEST["head"])));
	audit ("добавил шаблон СЗ","sz");
}

if (isset($_REQUEST["save"]))
{
	Table_update("sz_tpl",array("dpt_id"=>$_SESSION["dpt_id"],"id"=>$_REQUEST["id"]),array("text"=>addslashes($_REQUEST["text"]),"head"=>addslashes($_REQUEST["head"])));
	audit ("сохранил шаблон СЗ","sz");
}


if (isset($_REQUEST["del"]))
{
	Table_update("sz_tpl",array("dpt_id"=>$_SESSION["dpt_id"],"id"=>$_REQUEST["id"]),null);
	audit ("удалил шаблон СЗ","sz");
}




$sql=rtrim(file_get_contents('sql/sz_tpl.sql'));
$params=array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('sz_tpl', $data);

$smarty->display('sz_tpl.html');


?>