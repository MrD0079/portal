<?



$params=array(':dpt_id' => $_SESSION["dpt_id"],
	":tn"=>$tn,
	":dt"=>"'".$_REQUEST["dt"]."'",
);

$sql = rtrim(file_get_contents('sql/beg_routes_days_list.sql'));
$sql=stritr($sql,$params);
$days_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//echo $sql;
$smarty->assign('days_list', $days_list);
//print_r($days_list);


$sql = rtrim(file_get_contents('sql/beg_routes_week_days_list.sql'));
$week_days_list = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$smarty->assign('week_days_list', $week_days_list);

//print_r($week_days_list);


$first_day = $db->getOne("select dw from calendar where data = TRUNC (TO_DATE ('".$_REQUEST["dt"]."', 'dd.mm.yyyy'), 'mm')");
$smarty->assign('first_day', $first_day);



$smarty->display('beg_routes_days_list.html');

?>