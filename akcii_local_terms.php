<?

$sql=rtrim(file_get_contents('sql/akcii_local_terms.sql'));
$params=array(':z_id'=>$_REQUEST["z_id"]);
$sql=stritr($sql,$params);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

//print_r($data);

$smarty->assign("akcii_local_terms", $data);
$smarty->display('akcii_local_terms.html');


?>