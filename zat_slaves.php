<?


audit("открыл список подчиненных, заполнивших отчет о затратах","zat");




InitRequestVar("month_list");




$params = array
(
    ':sd' => "'".$_REQUEST["month_list"]."'",
    ':dpt_id' => $_SESSION["dpt_id"],
    ':tn' => $tn
    );
$sql = rtrim(file_get_contents('sql/zat_slaves.sql'));
$sql=stritr($sql,$params);
$zat_slaves = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('zat_slaves', $zat_slaves);






$sql = rtrim(file_get_contents('sql/month_list.sql'));
//$res = &$db->getAll($sql, MDB2_FETCHMODE_ASSOC);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);









$smarty->display('zat_slaves.html');


//echo $sql;
//print_r($zat_slaves);


?>