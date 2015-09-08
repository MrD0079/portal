<?


$p[":fil"] = $_REQUEST["fil"];

$sql = rtrim(file_get_contents('sql/bud_ru_cash_db.sql'));
$sql=stritr($sql,$p);
$dbl = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dbl', $dbl);


$smarty->display('bud_ru_cash_db.html');


?>