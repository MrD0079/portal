<?

//ses_req();

audit("открыл routes_add_tp","routes");

if (isset($_REQUEST["select_month"]))
{
	$_REQUEST["select_route_numb"]=null;
}

if (isset($_REQUEST["copy"]))
{
$sql1="DELETE FROM routes_head      WHERE tn = :tn AND data = TO_DATE (:month_list, 'dd/mm/yyyy')";
$sql2="
	INSERT INTO routes_head (parent, data)
	SELECT z.id, TO_DATE (:month_list, 'dd/mm/yyyy')
	FROM routes_head z
	WHERE tn = :tn
	AND data = ADD_MONTHS (TO_DATE (:month_list, 'dd/mm/yyyy'), -1)
";
$p=array(":tn"=>$tn,":month_list"=>"'".$_REQUEST["month_list"]."'");
$sql1 = stritr($sql1, $p);
$sql2 = stritr($sql2, $p);
//$db->query($sql1);
$db->query($sql2);
}

if (isset($_REQUEST["add_route"]))
{
	$affectedRows = $db->extended->autoExecute("routes_head", array("tn"=>$tn,"data"=>OraDate2MDBDate($_SESSION["month_list"])), MDB2_AUTOQUERY_INSERT);
}

if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$affectedRows = $db->extended->autoExecute("routes_head", null, MDB2_AUTOQUERY_DELETE, 'id='.$k);
	}
}

if (isset($_REQUEST["divide_go"]))
{
	foreach ($_REQUEST["divide_go"] as $k=>$v)
	{
		$sql="begin divide_route (:parent, TO_DATE (:divide_from, 'dd.mm.yyyy'), :divide_fio_otv); END;";
		$p=array(
			":parent"=>$k,
			":divide_from"=>"'".$_REQUEST["divide_from"][$k]."'",
			":divide_fio_otv"=>"'".$_REQUEST["divide_fio_otv"][$k]."'"
		);
		$sql = stritr($sql, $p);
		$db->Query($sql);
		audit("разделил маршрут: ".$sql,"routes");
	}
}

if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["copy2next_month"]))
	{
		foreach ($_REQUEST["copy2next_month"] as $k=>$v)
		{
			$affectedRows = $db->extended->autoExecute("routes_head", array('copy2next_month'=>$v), MDB2_AUTOQUERY_UPDATE, 'id='.$k);
		}
	}
	if (isset($_REQUEST["num"]))
	{
		foreach ($_REQUEST["num"] as $k=>$v)
		{
			$affectedRows = $db->extended->autoExecute("routes_head", array('num'=>$v), MDB2_AUTOQUERY_UPDATE, 'id='.$k);
		}
	}
	if (isset($_REQUEST["fio_otv"]))
	{
		foreach ($_REQUEST["fio_otv"] as $k=>$v)
		{
			$affectedRows = $db->extended->autoExecute("routes_head", array("fio_otv"=>$v), MDB2_AUTOQUERY_UPDATE, 'id='.$k);
		}
	}

	if (isset($_REQUEST["pos_otv"]))
	{
		foreach ($_REQUEST["pos_otv"] as $k=>$v)
		{
			$affectedRows = $db->extended->autoExecute("routes_head", array("pos_otv"=>$v), MDB2_AUTOQUERY_UPDATE, 'id='.$k);
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



//echo $sql;


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

$smarty->display('routes_add_tp.html');

?>