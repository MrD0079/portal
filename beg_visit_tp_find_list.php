<?

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);



$params=array(':dpt_id' => $_SESSION["dpt_id"],
	":tn"=>$tn,
	":dt"=>"'".$_REQUEST["dt"]."'",
	":find_string"=>"'".$_REQUEST["find_string"]."'"
);

$sql = rtrim(file_get_contents('sql/beg_visit_tp_list.sql'));
$sql=stritr($sql,$params);
$tp_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp_list', $tp_list);

$smarty->display('beg_visit_tp_find_list.html');

?>