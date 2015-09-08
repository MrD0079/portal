<?
$p = array(":id" => $_REQUEST["id"]);
$sql = rtrim(file_get_contents('sql/ac_test.sql'));
$sql=stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ac_test_a', $r);
$smarty->display('ac_test_a_items.html');
?>