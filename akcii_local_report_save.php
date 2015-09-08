<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$keys = array(
	'tp_kod'=>$_REQUEST['tp_kod'],
	'z_id'=>$_REQUEST['z_id']
);
Table_Update('akcii_local_tp', $keys,$keys);
if ($_REQUEST['field']=='tp_kod')
{
	if ($_REQUEST['val']==0)
	{
		Table_Update('akcii_local_tp', $keys,null);
	}
}
else
{
	$vals = array(
		$_REQUEST['field']=>$_REQUEST['val']
	);
	Table_Update('akcii_local_tp', $keys,$vals);
}
$params=array(
	':z_id' => $_REQUEST["z_id"],
	':tp_kod' => $_REQUEST["tp_kod"],
);
$sql = rtrim(file_get_contents('sql/akcii_local_report_get_zat.sql'));
$sql=stritr($sql,$params);
$x=$db->getOne($sql);
$smarty->assign("x", $x);
$smarty->display('akcii_local_report_save.html');
?>