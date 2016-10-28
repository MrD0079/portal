<?
//ses_req();
InitRequestVar("v_from",$now);
InitRequestVar("v_to",$now);
audit ("открыл форму создания отпусков","vacation");

if (isset($_REQUEST["add"])&&isset($_REQUEST["new_vacation"]))
{
	isset($_REQUEST["new_vacation"]["v_from"]) ? $_REQUEST["new_vacation"]["v_from"]=OraDate2MDBDate($_REQUEST["new_vacation"]["v_from"]) : null;
	isset($_REQUEST["new_vacation"]["v_to"]) ? $_REQUEST["new_vacation"]["v_to"]=OraDate2MDBDate($_REQUEST["new_vacation"]["v_to"]) : null;
	isset($_REQUEST["new_vacation"]["id"]) ? $id=$_REQUEST["new_vacation"]["id"] : $id=get_new_id();
	$_REQUEST["new_vacation"]["id"]=$id;
	Table_Update("vacation",array('id'=>$id),$_REQUEST["new_vacation"]);
	Table_Update("vacation_tasks",array('vac_id'=>$id),null);
	if (isset($_REQUEST["tasks"]))
	{
		foreach ($_REQUEST["tasks"] as $k=>$v)
		{
		foreach ($v as $k1=>$v1)
		{
			//$keys=v;
			$v1["vac_id"]=$id;
			$v1["part_id"]=$k;
			$v1["id"]=get_new_id();
			isset($v1["dt_end"]) ? $v1["dt_end"]=OraDate2MDBDate($v1["dt_end"]) : null;
			Table_Update("vacation_tasks",$v1,$v1);
		}
		}
	}
	$db->query("BEGIN PR_VACATION_SZ_CREATE (".$id."); END;");
}

$sql=rtrim(file_get_contents('sql/vacation_create.sql'));
$params=array(':tn' => $tn);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$d=$data;
foreach ($d as $k=>$v)
{
	$sql=rtrim(file_get_contents('sql/vacation_create_tasks.sql'));
	$params=array(':id' => $v["id"]);
	$sql=stritr($sql,$params);
	$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($data1 as $k1=>$v1)
	{
		$d[$k]["tasks"][$v1["part_id"]]["head"]=$v1;
		$d[$k]["tasks"][$v1["part_id"]]["data"][$v1["id"]]=$v1;
	}
}
isset($d) ? $smarty->assign('vacation', $d) : null;

$sql=rtrim(file_get_contents('sql/vacation_create_replacement.sql'));
$params=array(':tn' => $tn);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('vacation_replacement', $data);

$sql=rtrim(file_get_contents('sql/vacation_create_replacement_eta.sql'));
$params=array(':tn' => $tn);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('vacation_replacement_h_eta', $data);

$sql=rtrim(file_get_contents('sql/vacation_task_parts.sql'));
$params = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$vacation_task_parts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('vacation_task_parts', $vacation_task_parts);

$sql=rtrim(file_get_contents('sql/vacation_spr_planned.sql'));
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('planned', $x);

$sql=rtrim(file_get_contents('sql/vacation_spr_paided.sql'));
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('paided', $x);


$smarty->assign('vac_eta', $db->getOne('select vac_eta from pos where pos_id='.$_SESSION["my_pos_id"]));
$smarty->assign('vac_spd', $db->getOne('select vac_spd from pos where pos_id='.$_SESSION["my_pos_id"]));

$smarty->display('vacation_create.html');

?>