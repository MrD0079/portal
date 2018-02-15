<?


audit("открыл отчет планы активности","activ");



$sql = rtrim(file_get_contents('sql/dolgn_list.sql'));
//echo $sql;
$dolgn_list = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$smarty->assign('dolgn_list', $dolgn_list);
//print_r($dolgn_list);


$sql = rtrim(file_get_contents('sql/month_list.sql'));
//$res = $db->getAll($sql, MDB2_FETCHMODE_ASSOC);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);


//print_r($res);

//exit;


!isset($_REQUEST["dolgn_list"]) ? $_REQUEST["dolgn_list"]=0: null;
!isset($_REQUEST["exist_daily_plans_count"]) ? $_REQUEST["exist_daily_plans_count"]=0: null;
!isset($_REQUEST["exp_list"]) ? $_REQUEST["exp_list"]=0: null;


$params = array
(
    ':exp_tn' => $tn,
    ':data' => "'".$_REQUEST["month_list"]."'",
    ':dolgn_id'=> $_REQUEST["dolgn_list"],
    ':dpt_id' => $_SESSION["dpt_id"],
    ':exist_daily_plans_count'=> $_REQUEST["exist_daily_plans_count"]
    );
//print_r($params);
$sql = rtrim(file_get_contents('sql/plans.sql'));
$sql=stritr($sql,$params);
//echo $sql;
//$plans = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$plans = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

if (PEAR::isError($plans)) { echo $plans->getMessage(); }

$smarty->assign('plans', $plans);

//print_r($plans);


$params = array
(
    ':exp_tn' => $_REQUEST["exp_list"],
    ':data' => "'".$_REQUEST["month_list"]."'",
    ':dolgn_id'=> $_REQUEST["dolgn_list"],
    ':dpt_id' => $_SESSION["dpt_id"],
    ':exist_daily_plans_count'=> $_REQUEST["exist_daily_plans_count"]
    );
$sql = rtrim(file_get_contents('sql/exp_list.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$exp_list = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
//$exp_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list', $exp_list);




$sql = rtrim(file_get_contents('sql/plans_ok.sql'));
$sql=stritr($sql,$params);
//echo $sql;
//$plans_ok = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$plans_ok = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('plans_ok', $plans_ok);




$smarty->display('plans.html');



?>