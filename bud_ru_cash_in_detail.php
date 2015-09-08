<?

audit("открыл bud_ru_cash_in","bud");

$p = array();
$p[":dpt_id"] = $_SESSION["dpt_id"];
$p[":dt"] = "'".$_REQUEST["dt"]."'";

$sql = rtrim(file_get_contents('sql/bud_ru_cash_in_detail.sql'));
$sql=stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($r as $k=>$v)
{
$p[":id"] = $v["id"];
$sql = rtrim(file_get_contents('sql/bud_ru_cash_in_detail_body.sql'));
$sql=stritr($sql,$p);
$rd = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$r[$k]["body"]=$rd;
}

$smarty->assign('pd', $r);

$sql = rtrim(file_get_contents('sql/bud_ru_cash_in_detail_total.sql'));
$sql=stritr($sql,$p);
$r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pdt', $r);

$smarty->display('bud_ru_cash_in_detail.html');
?>