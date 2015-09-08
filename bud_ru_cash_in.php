<?

audit("открыл bud_ru_cash_in","bud");

$p = array();

if (isset($_REQUEST["head_id"]))
{
	$head_id=$_REQUEST["head_id"];
}
else
{
	if (isset($_REQUEST["head"]))
	{
		if (isset($_REQUEST["head"]["fil"])&&isset($_REQUEST["head"]["dt"])&&isset($_REQUEST["head"]["db"]))
		{
			$x = $db->getOne("SELECT id FROM bud_ru_cash_in_head WHERE fil = ".$_REQUEST["head"]["fil"]." AND dt = TO_DATE ('".$_REQUEST["head"]["dt"]."', 'dd.mm.yyyy') AND db = ".$_REQUEST["head"]["db"]."");
			if ($x)
			{
				$head_id=$x;
			}
			else
			{
				$head_id=get_new_id();
			}
		}
		else
		{
			$head_id=get_new_id();
		}
	}
}

if (isset($_REQUEST["save_record"]))
{
	$keys = array("id"=>$head_id);
	$v = $_REQUEST["head"];
	isset($v["dt"]) ? $v["dt"] = OraDate2MDBDate($v["dt"]) : null;
	Table_Update("bud_ru_cash_in_head", $keys, $v);
	if (isset($_REQUEST["enabled"]))
	{
		foreach ($_REQUEST["enabled"] as $k=>$v)
		{
			$keys = array("head_id"=>$head_id,"st"=>$_REQUEST["body"][$k]["st"]);
			($v==1)?$vals=$_REQUEST["body"][$k]:$vals=null;
			Table_Update("bud_ru_cash_in_body", $keys,$vals);
		}
	}
	$p[":id"] = $head_id;
	$sql = rtrim(file_get_contents('sql/bud_ru_cash_in_head.sql'));
	$sql=stritr($sql,$p);
	$rd = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$_REQUEST["head"]=$rd;
}

if (isset($_REQUEST["del_heads"]))
{
	foreach ($_REQUEST["del_heads"] as $k=>$v)
	{
		Table_Update("bud_ru_cash_in_head", array("id"=>$k),null);
	}
}

$p[":tn"] = $tn;
$p[":dpt_id"] = $_SESSION["dpt_id"];

$sql = rtrim(file_get_contents('sql/bud_ru_cash_dt.sql'));
$sql=stritr($sql,$p);
$dt = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dt', $dt);

$sql=rtrim(file_get_contents('sql/bud_fil.sql'));
$sql=stritr($sql,$p);
$fil = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('fil', $fil);

$smarty->display('bud_ru_cash_in.html');
//$smarty->display('bud_end.html');
?>