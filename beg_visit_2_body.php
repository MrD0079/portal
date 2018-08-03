<?



//InitRequestVar("dt",$now);



$params=array(
	":grup"=>"'".$_REQUEST["grup"]."'",
	":head"=>$_REQUEST["head"]
);

$sql = rtrim(file_get_contents('sql/beg_visit2_sku.sql'));
$sql=stritr($sql,$params);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);

$sql = rtrim(file_get_contents('sql/beg_visit2_grup.sql'));
$sql=stritr($sql,$params);
$grup = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('grup', $grup);

$sql = rtrim(file_get_contents('sql/beg_visit2_grupname.sql'));
$sql=stritr($sql,$params);
$grupname = $db->getOne($sql);
$smarty->assign('grupname', $grupname);

$smarty->display('beg_visit_2_body.html');

?>