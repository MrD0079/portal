<?

//ses_req();

audit("открыл routes_add_tp","routes");

if (isset($_REQUEST["select_month"]))
{
	$_REQUEST["select_route_numb"]=null;
}

if (isset($_REQUEST["add_route"]))
{
	Table_Update("routes_head", array("tn"=>$tn,"data"=>OraDate2MDBDate($_SESSION["month_list"])), array("tn"=>$tn,"data"=>OraDate2MDBDate($_SESSION["month_list"])));
}

if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_Update("routes_head", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["divide_go"]))
{
	foreach ($_REQUEST["divide_go"] as $k=>$v)
	{
		$sql="begin divide_route (:parent, TO_DATE (:divide_from, 'dd.mm.yyyy'), :divide_spr_users_ms); END;";
		$p=array(
			":parent"=>$k,
			":divide_from"=>"'".$_REQUEST["divide_from"][$k]."'",
			":divide_spr_users_ms"=>"'".$_REQUEST["divide_spr_users_ms"][$k]."'"
		);
		$sql = stritr($sql, $p);
                //echo $sql;
		$db->Query($sql);
		audit("разделил маршрут: ".$sql,"routes");
	}
}

if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["spr_users_ms"]))
	{
		foreach ($_REQUEST["spr_users_ms"] as $k=>$v)
		{
			Table_Update("routes_head", array('id'=>$k), array('login'=>$v));
		}
	}
	if (isset($_REQUEST["copy2next_month"]))
	{
		foreach ($_REQUEST["copy2next_month"] as $k=>$v)
		{
			Table_Update("routes_head", array('id'=>$k), array('copy2next_month'=>$v));
		}
	}
	if (isset($_REQUEST["num"]))
	{
		foreach ($_REQUEST["num"] as $k=>$v)
		{
			Table_Update("routes_head", array('id'=>$k), array('num'=>$v));
		}
	}
	if (isset($_REQUEST["rb"]))
	{
		$table_name = "routes_tp";
		foreach ($_REQUEST["rb"] as $k => $v)
		{
			foreach ($v as $k1 => $v1)
			{
			if ($v1!="")
			{
				$keys = array('head_id'=>$_REQUEST["select_route_numb"],'kodtp'=>$k1,'vv'=>0);
				if ($v1==1)
				{
		        		Table_Update ($table_name, $keys, $keys);
				}
				if ($v1==0)
				{
		        		Table_Update ($table_name, $keys, null);
				}
			}
			}
		}
	}
}

$sql = rtrim(file_get_contents('sql/routes_head.sql'));
$p=array(":tn"=>$tn,":month_list"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach($res as $k=>$v){
        $sql=rtrim(file_get_contents('sql/routes_add_tp_getDisabledDates.sql'));
        $p=array(":route"=>$v["id"]);
        $sql=stritr($sql,$p);
        $dd = $db->getOne($sql);
        $res[$k]["DisabledDates"]=$dd;
}

$smarty->assign('routes_head', $res);

if (isset($_REQUEST["select_route_numb"]))
{
    if ($_REQUEST["select_route_numb"]!="")
    {
        $sql = rtrim(file_get_contents('sql/routes_add_tp.sql'));
        $p=array(":route"=>$_REQUEST["select_route_numb"]);
        $sql=stritr($sql,$p);
        $rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
        $smarty->assign('d', $rb);

        $sql = rtrim(file_get_contents('sql/routes_add_tp_total.sql'));
        $p=array(":route"=>$_REQUEST["select_route_numb"]);
        $sql=stritr($sql,$p);
        $res = $db->getOne($sql);
        $smarty->assign('rb_total', $res);
    }
}

$sql = rtrim(file_get_contents('sql/routes_pos.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_pos', $res);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql=rtrim(file_get_contents('sql/spr_users_ms.sql'));
$p = array(":tn"=>$tn,':dpt_id' => $_SESSION["dpt_id"],':flt'=>0);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spr_users_ms', $data);

$smarty->display('routes_add_tp.html');

?>