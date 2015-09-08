<?
$p = array(":id" => $_REQUEST["id"]);
$sql = rtrim(file_get_contents('sql/clusters_fils.sql'));
$sql=stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('clusters_fils', $r);
$smarty->display('clusters_fils_items.html');
?>