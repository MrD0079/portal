<?
$p = array(":id" => $_REQUEST["id"]);
$sql = rtrim(file_get_contents('sql/pers_cats.sql'));
$sql=stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pers_cats', $r);
$smarty->display('pers_cats_items.html');
?>