<?


$params=array(':tn' => $tn);

$sql=rtrim(file_get_contents('sql/tmc_my.sql'));
$sql=stritr($sql,$params);
$tmc_my = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tmc_my', $tmc_my);
$smarty->display('tmc_my.html');

?>