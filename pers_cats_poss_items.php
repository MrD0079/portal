<?
$p = array(":id" => $_REQUEST["id"]);
$sql = rtrim(file_get_contents('sql/pers_cats_poss.sql'));
$sql=stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pers_cats_poss', $r);
$smarty->display('pers_cats_poss_items.html');
?>