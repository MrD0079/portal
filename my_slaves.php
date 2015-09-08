<?php




InitRequestVar("month_list");




audit("открыл планы активности подчиненных","activ");

$sql = rtrim(file_get_contents('sql/dates_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dates_list', $res);




$params = array
(
    ':sd' => "'".$_REQUEST["month_list"]."'",
    ':tn' => $tn,
    ':dpt_id'=>$_SESSION["dpt_id"]
    );
$sql = rtrim(file_get_contents('sql/my_slaves_plans.sql'));
$sql=stritr($sql,$params);
$my_slaves_plans = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
if (PEAR::isError($my_slaves_plans)) { echo $my_slaves_plans->getMessage(); }
$smarty->assign('my_slaves_plans', $my_slaves_plans);




//$smarty->display('my_slaves_plans.html');





$sql = rtrim(file_get_contents('sql/month_list.sql'));
//$res = &$db->getAll($sql, MDB2_FETCHMODE_ASSOC);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);







$smarty->display('my_slaves.html');

?>