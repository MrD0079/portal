<?


audit("открыл список подчиненных","razv");

$params = array
(
    ':exp_tn' => $tn,
    ':dpt_id' => $_SESSION["dpt_id"]
    );

$sql = rtrim(file_get_contents('sql/razv_slaves_full_1.sql'));
$sql=stritr($sql,$params);
$razv_slaves = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('razv_slaves_full_1', $razv_slaves);

$sql = rtrim(file_get_contents('sql/razv_slaves_full_0.sql'));
$sql=stritr($sql,$params);
$razv_slaves = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('razv_slaves_full_0', $razv_slaves);

$smarty->display('razv_slaves.html');

?>