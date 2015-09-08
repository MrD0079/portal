<?

$sql=rtrim(file_get_contents('sql/tmc_doubled.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $data);
$smarty->display('tmc_doubled.html');

?>