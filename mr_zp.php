<?php
if (isset($_REQUEST["save"]))
{
	audit("�������� �/� �� �����","mr_zp");
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('id'=>$_REQUEST['id']);
	$vals = array($_REQUEST['field']=>$_REQUEST['val'],'pin_lu_fio'=>$fio);
	Table_Update('mr_zp', $keys,$vals);
}
else
{
audit("������ �/� �� �����","mr_zp");
$sql = rtrim(file_get_contents('sql/mr_zp.sql'));
$p=array(":month_list"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $d);
$sql = rtrim(file_get_contents('sql/month_list.sql'));
//echo $sql;
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);
$smarty->display('mr_zp.html');
}
?>