<?
if (isset($_REQUEST["save"]))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('pos_id'=>$_REQUEST['pos_id'],'dpt_id'=>$_SESSION['dpt_id']);
	$vals = array('val'=>$_REQUEST['val'],'lu_fio'=>$fio);
	Table_Update('advance_pos', $keys,$vals);
}
else
{
	$p = array(':dpt_id'=>$_SESSION['dpt_id']);
	$sql = rtrim(file_get_contents('sql/advance_pos.sql'));
	$sql=stritr($sql,$p);
	$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('advance_pos', $r);
	$smarty->display('advance_pos.html');
}
?>