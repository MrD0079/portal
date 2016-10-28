<?
if (isset($_REQUEST['new']))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$id=get_new_id();
	$smarty->assign('id',$id);
	$smarty->display('dm_cat_appeals_new.html');
}
else
if (isset($_REQUEST['del']))
{
	$keys = array('id'=>$_REQUEST['id']);
	Table_Update('dm_cat_appeals', $keys,null);
}
else
if (isset($_REQUEST['save']))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('id'=>$_REQUEST['id']);
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	Table_Update('dm_cat_appeals', $keys,$vals);
}
else
{
	$sql = rtrim(file_get_contents('sql/dm_cat_appeals.sql'));
	$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('dm_cat_appeals', $r);
	$smarty->display('dm_cat_appeals.html');
}
?>