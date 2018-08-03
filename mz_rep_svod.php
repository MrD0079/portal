<?





InitRequestVar("sd",$_SESSION["month_list"]);
InitRequestVar("ed",$_SESSION["month_list"]);
InitRequestVar("dataz",0);

$params = array(
	':dataz' => $_REQUEST["dataz"],
	':sd' => "'".$_REQUEST["sd"]."'",
	':ed' => "'".$_REQUEST["ed"]."'"
	);











$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);


$sql=rtrim(file_get_contents('sql/mz_rep_svod.sql'));
$sql=stritr($sql,$params);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);


foreach ($res as $k=>$v)
{
$d[$v["id"]]["head"]=$v;
$d[$v["id"]]["data"][$v["p_name"]]=$v;
}

foreach ($res as $k=>$v)
{
$d1[$v["p_name"]]=$v["p_name"];
}


//print_r($d);





isset($d)?$smarty->assign('d', $d):null;
isset($d1)?$smarty->assign('d1', $d1):null;

$sql=rtrim(file_get_contents('sql/mz_rep_svod_total.sql'));
$sql=stritr($sql,$params);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);


foreach ($res as $k=>$v)
{
$dt["head"]=$v;
$dt["data"][$v["p_name"]]=$v;
}


isset($dt)?$smarty->assign('dt', $dt):null;





//print_r($dt);



$smarty->display('mz_rep_svod.html');


?>