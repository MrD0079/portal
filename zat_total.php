<?



audit("открыл отчет 'Общие затраты команды для начисления ЗП'","zat");

$m=substr($_REQUEST["month_list"], 3, 2);
$y=substr($_REQUEST["month_list"], 6, 4);


$smarty->assign('zat_total_m', $m);
$smarty->assign('zat_total_y', $y);

if (isset($_REQUEST["save"]))
{
	foreach($_REQUEST["avans"] as $k=>$v)
	{
		$keys = array(
			"tn"=>$k,
			"m"=>$m,
			"y"=>$y
		);
		Table_Update ("zat_monthly", $keys, array("avans"=>$v));
	}
}

$params = array
(
    ':exp_tn' => 0,
    ':sd' => "'".$_REQUEST["month_list"]."'",
    ':dpt_id' => $_SESSION["dpt_id"],
    ':is_accepted'=> "1",
    ':is_processed'=> "1"
    );
$sql = rtrim(file_get_contents('sql/zat_ok.sql'));
$sql=stritr($sql,$params);
//echo $sql;
//$zat_ok = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$zat_ok = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($zat_ok);
$smarty->assign('zat_total', $zat_ok);


$smarty->display('zat_total.html');






?>