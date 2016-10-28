<?
if (isset($_REQUEST['new'])) {
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$id=get_new_id();
	$keys = array('id'=>$id,'cat'=>$_REQUEST['cat'],'ag_id'=>$_REQUEST['ag_id']);
	Table_Update('ms_ag_cat', $keys,$keys);
	$smarty->assign('id',$id);
	$smarty->assign('cat',$_REQUEST['cat']);
	$smarty->display('ms_ag_cat_new.html');
} else if (isset($_REQUEST['items'])) {
	$p = array(":id" => $_REQUEST["id"]);
	$sql = rtrim(file_get_contents('sql/ms_ag_cat.sql'));
	$sql=stritr($sql,$p);
	$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('ms_ag_cat', $r);
	$smarty->display('ms_ag_cat_items.html');
} else if (isset($_REQUEST['save'])) {
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('id'=>$_REQUEST['id']);
	Table_Update('ms_ag_cat', $keys,$keys);
	if ($_REQUEST['field']=='id')
	{
		if ($_REQUEST['val']==0){Table_Update('ms_ag_cat', $keys,null);}
	}
	else
	{
		$vals = array($_REQUEST['field']=>$_REQUEST['val']);
		Table_Update('ms_ag_cat', $keys,$vals);
	}
} else {
	$sql = rtrim(file_get_contents('sql/routes_agents.sql'));
	$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('agents', $r);
	$smarty->display('ms_ag_cat.html');
}
?>