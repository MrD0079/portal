<?
$p = array(":id" => $_REQUEST["id"]/*,':dpt_id'=>$_SESSION['dpt_id']*/);
$sql = rtrim(file_get_contents('sql/dpnr_statyas.sql'));
$sql=stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dpnr_statyas', $r);
$smarty->display('dpnr_statyas_items.html');
?>