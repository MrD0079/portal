<?
if (isset($_REQUEST["save"]))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys=array("id"=>$_REQUEST["id"]);
	$vals=array($_REQUEST["field"]=>$_REQUEST["val"]);
	//print_r($keys);
	//print_r($vals);
	Table_Update("iv_".$_REQUEST["tbl"],$keys,$vals);
	echo "Сохранено";
}
else
{
$sql=rtrim(file_get_contents('sql/iv_accept_head.sql'));
$params=array(':tn' => $tn);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($data as $k=>$v)
{
$sql=rtrim(file_get_contents('sql/iv_accept_body.sql'));
$params=array(':id' => $v['id']);
$sql=stritr($sql,$params);
$datab = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$data[$k]["body"]=$datab;
}
$smarty->assign('ivl', $data);
$sql=rtrim(file_get_contents('sql/iv_st.sql'));
$iv_st = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('iv_st', $iv_st);
$smarty->display('iv_accept.html');
}
?>