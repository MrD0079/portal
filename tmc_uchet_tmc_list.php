<?


audit ("открыл учет ТМЦ ".$_REQUEST["tn"],"tmc");

$sql=rtrim(file_get_contents('sql/emp_exp_spd_list.sql'));
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('emp', $d);


$sql=rtrim(file_get_contents('sql/tmcs.sql'));
$tmcs = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tmcs', $tmcs);


$params=array(':tn' => $_REQUEST["tn"]);
$sql=rtrim(file_get_contents('sql/tmc.sql'));
$sql=stritr($sql,$params);
$tmc = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tmc', $tmc);

$smarty->display('tmc_uchet_tmc_list.html');

?>