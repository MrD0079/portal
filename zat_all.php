<?

audit("открыл отчет 'заполнение отчета'","zat");

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
!isset($_REQUEST["exist_daily_zat_count"]) ? $_REQUEST["exist_daily_zat_count"]=0: null;
!isset($_REQUEST["exp_list_processed"]) ? $_REQUEST["exp_list_processed"]=0: null;
!isset($_REQUEST["exp_list_accepted"]) ? $_REQUEST["exp_list_accepted"]=0: null;
!isset($_REQUEST["is_accepted"]) ? $_REQUEST["is_accepted"]="10": null;
!isset($_REQUEST["is_processed"]) ? $_REQUEST["is_processed"]="10": null;


$params = array
(
    ':exp_tn' => $tn,
    ':data' => "'".$_REQUEST["month_list"]."'",
    ':dpt_id' => $_SESSION["dpt_id"],
    ':dolgn_id'=> $_REQUEST["dolgn_list"],
    ':exist_daily_zat_count'=> $_REQUEST["exist_daily_zat_count"]
    );
//print_r($params);
$sql = rtrim(file_get_contents('sql/zat_all.sql'));
$sql=stritr($sql,$params);
//echo $sql;
//$zat = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$zat = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

if (PEAR::isError($zat)) { echo $zat->getMessage(); }

$smarty->assign('zat', $zat);

//print_r($zat);


$params = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql = rtrim(file_get_contents('sql/exp_list.sql'));
$sql=stritr($sql,$params);
$exp_list = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list', $exp_list);



$params = array
(
    ':exp_tn' => $_REQUEST["exp_list_accepted"],
    ':sd' => "'".$_REQUEST["month_list"]."'",
    ':dpt_id' => $_SESSION["dpt_id"],
    ':is_accepted'=> $_REQUEST["is_accepted"],
    ':is_processed'=> "10"
    );
$sql = rtrim(file_get_contents('sql/zat_ok.sql'));
$sql=stritr($sql,$params);
//echo $sql;
//$zat_ok = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$zat_ok = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($zat_ok);
$smarty->assign('zat_accepted', $zat_ok);


$params = array
(
    ':exp_tn' => $_REQUEST["exp_list_processed"],
    ':sd' => "'".$_REQUEST["month_list"]."'",
    ':dpt_id' => $_SESSION["dpt_id"],
    ':is_accepted'=> "1",
    ':is_processed'=> $_REQUEST["is_processed"]
    );
$sql = rtrim(file_get_contents('sql/zat_ok.sql'));
$sql=stritr($sql,$params);
//echo $sql;
//$zat_ok = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$zat_ok = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($zat_ok);
$smarty->assign('zat_processed', $zat_ok);





$smarty->display('zat_all.html');



?>