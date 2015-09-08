<?

audit ("открыл реестр ТМЦ","tmc");
//ses_req();

$sql=
"
SELECT TO_CHAR (MIN (dtv), 'dd.mm.yyyy') min_dt,
       TO_CHAR (MAX (dtv), 'dd.mm.yyyy') max_dt
  FROM tmc
";
$dt = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

InitRequestVar("dates_list_t_1",$dt["min_dt"]);
InitRequestVar("dates_list_t_2",$dt["max_dt"]);
InitRequestVar("who",0);
InitRequestVar("status",0);
InitRequestVar("owner",0);
InitRequestVar("country",'0');
InitRequestVar("orderby",1);
InitRequestVar("tmc_pos_id",0);
InitRequestVar("region_name","0");
InitRequestVar("department_name","0");
InitRequestVar("tmc_id",0);
InitRequestVar("removed",0);
InitRequestVar("sn",'');

$params=array(
':tn' => $tn,
':dpt_id' => $_SESSION["dpt_id"],
":dates_list_t_1"=>"'".$_REQUEST["dates_list_t_1"]."'",
":dates_list_t_2"=>"'".$_REQUEST["dates_list_t_2"]."'",
":status"=>$_REQUEST["status"],
":owner"=>$_REQUEST["owner"],
":who"=>$_REQUEST["who"],
":orderby"=>$_REQUEST["orderby"],
":country"=>"'".$_REQUEST["country"]."'",
":tmc_pos_id"=>$_REQUEST["tmc_pos_id"],
":region_name"=>"'".$_REQUEST["region_name"]."'",
":department_name"=>"'".$_REQUEST["department_name"]."'",
":removed"=>$_REQUEST["removed"],
":sn"=>"'".$_REQUEST["sn"]."'",
);

$sql = rtrim(file_get_contents('sql/tmc_reestr_owners_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('owners_list', $data);

$sql = rtrim(file_get_contents('sql/tmc_reestr_pos_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos_list', $data);

$sql = rtrim(file_get_contents('sql/tmc_reestr_region_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('region_list', $data);

$sql = rtrim(file_get_contents('sql/tmc_reestr_department_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('department_list', $data);

if (isset($_REQUEST["select"]))
{

$sql=rtrim(file_get_contents('sql/tmc_reestr.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $data);

$sql=rtrim(file_get_contents('sql/tmc_reestr_total.sql'));
$sql=stritr($sql,$params);
$data = $db->getOne($sql);
$smarty->assign('d1', $data);

}


$smarty->display('tmc_reestr.html');



//ses_req();



?>