<?

audit ("открыл реестр СЗ","reserv");

InitRequestVar("executor",0);
InitRequestVar("creator",0);
InitRequestVar("country",$_SESSION["cnt_kod"]);
InitRequestVar("res_pos_id",0);
InitRequestVar("region_name","0");
InitRequestVar("department_name","0");
InitRequestVar("exp_list_without_ts",0);

$params=array(
':tn' => $tn,
':dpt_id' => $_SESSION["dpt_id"],
":country"=>"'".$_REQUEST["country"]."'",
':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
":res_pos_id"=>$_REQUEST["res_pos_id"],
":region_name"=>"'".$_REQUEST["region_name"]."'",
":department_name"=>"'".$_REQUEST["department_name"]."'",
);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

$sql = rtrim(file_get_contents('sql/reserv_res_pos_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('res_pos_list', $data);

$sql = rtrim(file_get_contents('sql/reserv_region_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('region_list', $data);

$sql = rtrim(file_get_contents('sql/reserv_department_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('department_list', $data);

if (isset($_REQUEST["select"]))
{
$sql=rtrim(file_get_contents('sql/reserv.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $data);
}

$smarty->display('reserv.html');

?>