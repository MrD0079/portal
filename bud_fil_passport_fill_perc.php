<?


$sql=rtrim(file_get_contents('sql/bud_fil_passport_fill_perc.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);

$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $x);

$smarty->display('bud_fil_passport_fill_perc.html');


?>