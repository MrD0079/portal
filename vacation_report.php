<?



$params=array(
	':tn'=>$tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':eta' => "'".$_SESSION["h_eta"]."'"
);

if (isset($_REQUEST['save']))
{
	if (isset($_REQUEST['tasks']))
	{
		foreach ($_REQUEST["tasks"] as $k=>$v)
		{
			Table_Update("vacation_tasks", array("id"=>$k),$v);
		}
	}
	if (isset($_REQUEST['vac']))
	{
		foreach ($_REQUEST["vac"] as $k=>$v)
		{
			Table_Update("vacation", array("id"=>$k),$v);
		}
	}
}

/*
$sql=rtrim(file_get_contents('sql/main_tasks_vacation_report_cnt.sql'));
$sql=stritr($sql,$params);
$data = $db->getOne($sql);
$smarty->assign('vacation_report_cnt', $data);
*/

$sql=rtrim(file_get_contents('sql/vacation_report.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($x as $k=>$v)
{
$d[$v["id"]]["head"]=$v;
$sql=rtrim(file_get_contents('sql/vacation_create_tasks.sql'));
$params=array(':id' => $v["id"]);
$sql=stritr($sql,$params);
//echo $sql;
$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($data1 as $k1=>$v1)
{
	$d[$v["id"]]["data"][$v1["part_id"]]["head"]=$v1;
	$d[$v["id"]]["data"][$v1["part_id"]]["data"][$v1["id"]]=$v1;
}
}
//print_r($d);
isset($d) ? $smarty->assign('vacation_task_parts', $d) : null;

$smarty->display('vacation_report.html');

?>