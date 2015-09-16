<?
$ref = [
'customers',
];
foreach ($ref as $v)
{
	$smarty->assign('dzc_ref'.$v, $db->getAll(rtrim(file_get_contents('sql/dzc_ref'.$v.'.sql')), null, null, null, MDB2_FETCHMODE_ASSOC));
}

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$_REQUEST['id']!=='0'?$id=$_REQUEST['id']:$id=get_new_id();

$smarty->assign('id', $id);
//echo $id;
//$_REQUEST['id']=$id;
$smarty->display('dzc_new_list.html');
//ses_req();
//print_r($_REQUEST);
?>