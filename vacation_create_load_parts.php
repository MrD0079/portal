<?

$sql=rtrim(file_get_contents('sql/vacation_create_tasks.sql'));



$params=array(':id' => $_REQUEST["id"]);
$sql=stritr($sql,$params);
//echo $sql;
$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($data1 as $k1=>$v1)
{
	$d[$v1["part_id"]]["head"]=$v1;
	$d[$v1["part_id"]]["data"][$v1["id"]]=$v1;
}
isset($d) ? $smarty->assign('vacation_task_parts', $d) : null;


//print_r($d);

$smarty->display('vacation_create_load_parts.html');

?>