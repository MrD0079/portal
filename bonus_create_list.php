<?
$sql=rtrim(file_get_contents('sql/bonus_create_list_'.$_REQUEST['type'].'.sql'));
$params=array(':tn' => $tn, ':dpt_id' => $_SESSION['dpt_id']);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $data);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql=rtrim(file_get_contents('sql/currencies.sql'));
$currencies = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('currencies', $currencies);

$_REQUEST['id']!=='0'?$id=$_REQUEST['id']:$id=get_new_id();

$smarty->assign('id', $id);
//echo $id;
//$_REQUEST['id']=$id;
$smarty->display('bonus_create_list.html');

//print_r($_REQUEST);
?>