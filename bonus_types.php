<?
if (isset($_REQUEST["items"]))
{
$p = array(":id" => $_REQUEST["id"]/*,':dpt_id'=>$_SESSION['dpt_id']*/);
$sql = rtrim(file_get_contents('sql/bonus_types.sql'));
$sql=stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bonus_types', $r);
$smarty->display('bonus_types_items.html');
}
else
if (isset($_REQUEST["new"]))
{
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$id=get_new_id();
$keys = array('id'=>$id,'name'=>$_REQUEST['new_name'],'parent'=>$_REQUEST['parent']/*,'dpt_id'=>$_SESSION['dpt_id']*/);
Table_Update('bonus_types', $keys,$keys);
$_REQUEST['id']=$_REQUEST['parent'];
$smarty->assign('id',$id);
$smarty->assign('name',$_REQUEST['new_name']);
$smarty->display('bonus_types_new.html');
}
else
if (isset($_REQUEST["save"]))
{
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$keys = array('id'=>$_REQUEST['id']);
Table_Update('bonus_types', $keys,$keys);
if ($_REQUEST['field']=='id')
{
	if ($_REQUEST['val']==0){Table_Update('bonus_types', $keys,null);}
}
else
{
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	Table_Update('bonus_types', $keys,$vals);
}
}
else
{
$smarty->display('bonus_types.html');
}
?>