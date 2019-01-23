<?

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("fil",0);
InitRequestVar("clusters",0);
InitRequestVar("db",0);
InitRequestVar("dt",$_SESSION["month_list"]);

$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':dt' => "'".$_REQUEST["dt"]."'",
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
	':ok_selected' => 2,
	':db' => $_REQUEST["db"],
	':fil' => $_REQUEST["fil"],
	':clusters' => $_REQUEST["clusters"],
);


$sql = rtrim(file_get_contents('sql/bud_svod_act_list.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//echo $sql;
foreach ($x as $k=>$v)
{
    $params[':act']="'".$v['act']."'";
    $params[':m']=$v['month'];

    $sql = rtrim(file_get_contents('sql/bud_svod_act_list_detail.sql'));
    $sql=stritr($sql,$params);
    //echo $sql;
    $x[$k]['detail'] = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

    $sql = rtrim(file_get_contents('sql/bud_svod_act_list_total.sql'));
    $sql=stritr($sql,$params);
    //echo $sql;
    $x[$k]['total'] = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
}

$smarty->assign('akcii', $x);

$sql = rtrim(file_get_contents('sql/bud_svod_act_list_local.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($x as $k=>$v)
{
$params[':z_id']=$v['id'];

$sql = rtrim(file_get_contents('sql/bud_svod_act_list_local_detail.sql'));
$sql=stritr($sql,$params);
$x[$k]['detail'] = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

$sql = rtrim(file_get_contents('sql/bud_svod_act_list_local_total.sql'));
$sql=stritr($sql,$params);
$x[$k]['total'] = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
}

$smarty->assign('akcii_local', $x);

$smarty->display('bud_svod_act_list.html');

?>