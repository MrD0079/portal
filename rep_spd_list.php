<?
$sql = rtrim(file_get_contents('sql/rep_spd_list_db.sql'));
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('db_list', $r);
$sql = rtrim(file_get_contents('sql/month_list.sql'));
$dt = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dt', $dt);
if (isset($_REQUEST["new"]))
{
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$id=get_new_id();
$keys = array('id'=>$id,'fio'=>$_REQUEST['new_fio'],'tn'=>$_REQUEST['new_tn']);
Table_Update('rep_spd_list', $keys,$keys);
$smarty->assign('id',$id);
$smarty->assign('new_fio',$_REQUEST['new_fio']);
$smarty->assign('new_tn',$_REQUEST['new_tn']);
$smarty->display('rep_spd_list_new.html');
}
else
if (isset($_REQUEST["save"]))
{
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$keys = array('id'=>$_REQUEST['id']);
Table_Update('rep_spd_list', $keys,$keys);
if ($_REQUEST['field']=='id')
{
	if ($_REQUEST['val']==0){Table_Update('rep_spd_list', $keys,null);}
}
else
{
	$_REQUEST['field']=='last_month'?$_REQUEST['val']=OraDate2MDBDate($_REQUEST['val']):null;
	$_REQUEST['field']=='contract_end'?$_REQUEST['val']=OraDate2MDBDate($_REQUEST['val']):null;
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	Table_Update('rep_spd_list', $keys,$vals);
}
}
else
{
$p = array(":valid" => $_REQUEST["valid"]);
$sql = rtrim(file_get_contents('sql/rep_spd_list.sql'));
$sql=stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('rep_spd_list', $r);
$smarty->display('rep_spd_list.html');
}
?>