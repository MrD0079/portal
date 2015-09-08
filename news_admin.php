<?

if (isset($_REQUEST["add"]))
{
	Table_update("news",array("dpt_id"=>$_SESSION["dpt_id"],"id"=>0),array("text"=>addslashes($_REQUEST["text"])));
}

if (isset($_REQUEST["save"]))
{
	Table_update("news",array("dpt_id"=>$_SESSION["dpt_id"],"id"=>$_REQUEST["id"]),array("text"=>addslashes($_REQUEST["text"])));
}


if (isset($_REQUEST["del"]))
{
	Table_update("news",array("dpt_id"=>$_SESSION["dpt_id"],"id"=>$_REQUEST["id"]),null);
}




$sql=rtrim(file_get_contents('sql/news_admin.sql'));
$params=array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('news_admin', $data);

$smarty->display('news_admin.html');


?>