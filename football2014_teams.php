<?

audit ("открыл форму редактирования команд","football");


//ses_req();


if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("football_teams", array("id"=>$k),$v);
	}
}

if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("football_teams", null, MDB2_AUTOQUERY_DELETE, "id=".$k);
	}
}

if (isset($_REQUEST["new"]))
{

		Table_Update("football_teams", $_REQUEST["data_new"],$_REQUEST["data_new"]);
}

$p = array();
$p[':dpt_id'] = $_SESSION["dpt_id"];

$sql = rtrim(file_get_contents('sql/emp_exp_spd_list.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list', $data);

$sql = rtrim(file_get_contents('sql/departments.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('department_list', $data);

$sql = rtrim(file_get_contents('sql/football_teams.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('football_teams', $data);

$smarty->display('football_teams.html');

?>