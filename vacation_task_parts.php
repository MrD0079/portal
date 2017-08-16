<?


//ses_req();


audit("открыл vacation_task_parts","vacation_task_parts");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("vacation_task_parts", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"])&&isset($_REQUEST["delete"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
                Table_Update("vacation_task_parts", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["add"]))
{
	Table_Update("vacation_task_parts", array("id"=>get_new_id(),'dpt_id' => $_SESSION["dpt_id"]),$_REQUEST["new"]);
}

$sql=rtrim(file_get_contents('sql/vacation_task_parts.sql'));
$params = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$vacation_task_parts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('vacation_task_parts', $vacation_task_parts);

$smarty->display('vacation_task_parts.html');

?>