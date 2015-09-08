<?

if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["rb"])&&isset($_REQUEST["select_route_numb"]))
	{
		$table_name = "routes_body1";
		foreach ($_REQUEST["rb"] as $k => $v)
		{
		//echo $k."<br>";
			foreach ($v as $k1 => $v1)
			{
			foreach ($v1 as $k2 => $v2)
			{
			foreach ($v2 as $k3 => $v3)
			{
				//echo $k1."<br>";
				$keys = array(
					'head_id'=>$_REQUEST["select_route_numb"],
					'kodtp'=>$k1,
					'ag_id'=>$k2,
					'day_num'=>$k3,
					'vv'=>0);
				$values = array($k=>$v3);
				//$k3==1&&$k1==1004401600?print_r($keys):null;
				//$k3==1&&$k1==1004401600?print_r($values):null;
				Table_Update ($table_name, $keys, $values);
			}
			}
			}
		}
	}
}
else
{
	$sql = rtrim(file_get_contents('sql/routes_body_new_calendar.sql'));
	$p=array(":route"=>$_REQUEST["select_route_numb"]);
	$sql=stritr($sql,$p);
	$rbc = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('rbc', $rbc);

	$sql = rtrim(file_get_contents('sql/routes_body_new1.sql'));
	$p=array(
		":route"=>$_REQUEST["select_route_numb"],
		":tp"=>$_REQUEST["tp"],
		":ag"=>$_REQUEST["ag"],
	);
	$sql=stritr($sql,$p);
	$rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('d', $rb);

	$smarty->display('routes_form_calendar.html');
}

?>