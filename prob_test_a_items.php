<?
$p = array(":id" => $_REQUEST["id"]);
$sql = rtrim(file_get_contents('sql/prob_test.sql'));
$sql=stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('prob_test_a', $r);
$smarty->display('prob_test_a_items.html');
?>