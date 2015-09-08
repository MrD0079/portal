<?
$p = array(":id" => $_REQUEST["id"],':dpt_id'=>$_SESSION['dpt_id']);
$sql = rtrim(file_get_contents('sql/lists.sql'));
$sql=stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('lists', $r);
$smarty->display('lists_items.html');
?>