<?


$params=array(
	':login'=>"'".$login."'"
);

$sql=rtrim(file_get_contents('sql/ac_main_tests.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ac_tests', $data);




$smarty->display('ac_main.html');



?>