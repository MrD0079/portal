<?

audit("открыл bud_ru_cash_in","bud");

$p = array();

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
else
{
	if (isset($_REQUEST["head_id"]))
	{
		$head_id=$_REQUEST["head_id"];
	}
	else
	{
		$head_id=get_new_id();
	}
}

$p[":id"] = $head_id;
$p[":dpt_id"] = $_SESSION["dpt_id"];

$sql = rtrim(file_get_contents('sql/bud_ru_cash_in_head.sql'));
$sql=stritr($sql,$p);
$rd = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('head', $rd);

$sql = rtrim(file_get_contents('sql/bud_ru_cash_in_body.sql'));
$sql=stritr($sql,$p);
$rd = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('body', $rd);

$smarty->display('bud_ru_cash_in_body.html');

?>