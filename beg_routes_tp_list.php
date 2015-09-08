<?

$params=array(':dpt_id' => $_SESSION["dpt_id"],
	":tn"=>$tn,
	":dt"=>"'".$_REQUEST["dt"]."'",
	":ts_list"=>$_REQUEST["ts_list"],
	":eta_list"=>$_REQUEST["eta_list"]
);

$sql = rtrim(file_get_contents('sql/beg_routes_tp_list.sql'));
$sql=stritr($sql,$params);
$tp_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp_list', $tp_list);

$smarty->display('beg_routes_tp_list.html');

?>