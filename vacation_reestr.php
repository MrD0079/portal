<?


//InitRequestVar("v_from",$now);
//InitRequestVar("v_to",$now);


InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
InitRequestVar("replacement",0);
InitRequestVar("creator",0);
InitRequestVar("country",'0');
InitRequestVar("vac_pos_id",0);
InitRequestVar("region_name","0");
InitRequestVar("department_name","0");
InitRequestVar("parent_list",0);
InitRequestVar("in_vac",0);
InitRequestVar("vac_finished",0);
InitRequestVar("full",0);
InitRequestVar("planned",0);
InitRequestVar("paided",0);





audit ("открыл форму реестра отпусков","vacation");


$params=array(
':tn' => $tn,
':dpt_id' => $_SESSION["dpt_id"],
":dates_list1"=>"'".$_REQUEST["dates_list1"]."'",
":dates_list2"=>"'".$_REQUEST["dates_list2"]."'",
":replacement"=>$_REQUEST["replacement"],
":creator"=>$_REQUEST["creator"],
":country"=>"'".$_REQUEST["country"]."'",
":vac_pos_id"=>$_REQUEST["vac_pos_id"],
":region_name"=>"'".$_REQUEST["region_name"]."'",
":department_name"=>"'".$_REQUEST["department_name"]."'",
":parent_list"=>"'".$_REQUEST["parent_list"]."'",
":in_vac"=>$_REQUEST["in_vac"],
":vac_finished"=>$_REQUEST["vac_finished"],
":full"=>$_REQUEST["full"],
":planned"=>$_REQUEST["planned"],
":paided"=>$_REQUEST["paided"],
);

$sql = rtrim(file_get_contents('sql/vacation_reestr_parent_list.sql'));
$sql=stritr($sql,$params);
$vacation_reestr_parent_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('parent_list', $vacation_reestr_parent_list);

$sql = rtrim(file_get_contents('sql/vacation_reestr_creators_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('creators_list', $data);

$sql = rtrim(file_get_contents('sql/vacation_reestr_replacements_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('replacements_list', $data);

$sql = rtrim(file_get_contents('sql/vacation_reestr_pos_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos_list', $data);

$sql = rtrim(file_get_contents('sql/vacation_reestr_region_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('region_list', $data);

$sql = rtrim(file_get_contents('sql/vacation_reestr_department_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('department_list', $data);

$sql=rtrim(file_get_contents('sql/vacation_spr_planned.sql'));
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('planned', $x);

$sql=rtrim(file_get_contents('sql/vacation_spr_paided.sql'));
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('paided', $x);



$sql=rtrim(file_get_contents('sql/vacation_reestr.sql'));
//$params=array(':tn' => $tn);
$sql=stritr($sql,$params);
//echo $sql;
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($data);
$d=$data;
foreach ($d as $k=>$v)
{
	$sql=rtrim(file_get_contents('sql/vacation_reestr_tasks.sql'));
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

$smarty->display('vacation_reestr.html');

?>