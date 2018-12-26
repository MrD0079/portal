<?

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("ok_bonus",1);
InitRequestVar("cash",1);
InitRequestVar("fakt_gt_plan",1);
InitRequestVar("fil",0);
InitRequestVar("clusters",0);
InitRequestVar("dt",$_SESSION["month_list"]);

$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':dt' => "'".$_REQUEST["dt"]."'",
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
	':ok_bonus' => $_REQUEST["ok_bonus"],
	':cash' => $_REQUEST["cash"],
	':fakt_gt_plan' => $_REQUEST["fakt_gt_plan"],
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
	':fil' => $_REQUEST["fil"],
	':clusters' => $_REQUEST["clusters"],
);

$sql = rtrim(file_get_contents('sql/bud_svod_tus_tp_svodf.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$d=array();
if (isset($x))
{
foreach ($x as $k=>$v)
{
$v['fn']==null&&$v['fio_ts']==null&&$v['id']==null?$d['total']=$v['summa']:null;
$v['fn']==null&&$v['fio_ts']!==null&&$v['id']==null?$d['data'][$v['fio_ts']]['total']=$v['summa']:null;
$v['fn']!==null&&$v['fio_ts']!==null&&$v['id']!==null?$d['data'][$v['fio_ts']]['data'][$v['id']]=array('fn'=>$v['fn'],'summa'=>$v['summa']):null;
}
}
isset($d)?$smarty->assign('svodf', $d):null;


//add fix for close/open access to MA
$param_tmp = array(
    ':dt' => "'".$_REQUEST["dt"]."'"
);
$sql = rtrim(file_get_contents('sql/params_for_MAreport.sql'));
$sql=stritr($sql,$param_tmp);
$parameters = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$access_edit = false;
foreach ($parameters as $key => $param) {
    if($param['access_edit'] == 1){
        $access_edit = true;
    }
}
$smarty->assign('access_edit', $access_edit);
//end


$smarty->display('bud_svod_tus_tp_svodf.html');

?>