<?

audit("открыл bud_ru_cash_out","bud");

$p = array();
$p[":dpt_id"] = $_SESSION["dpt_id"];
$p[":dt"] = "'".$_REQUEST["dt"]."'";

$sql = rtrim(file_get_contents('sql/bud_ru_cash_out_detail.sql'));
$sql=stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($r as $k=>$v)
{

$p[":id"] = $v["id"];

foreach ($r as $k=>$v)
{
$p[":id"] = $v["id"];
$sql = rtrim(file_get_contents('sql/bud_ru_cash_out_detail_body.sql'));
$sql=stritr($sql,$p);
$rd = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($rd as $k1=>$v1)
{
$r[$k]["body"][$v1["st"]]=$v1;
}
}

foreach ($r as $k=>$v)
{
$p[":id"] = $v["id"];
$sql = rtrim(file_get_contents('sql/bud_ru_cash_out_detail_body1.sql'));
$sql=stritr($sql,$p);
$rd = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//$r[$k]["body"]=$rd;
//$r[$k]["body"][$rd["st"]]["body"]=$rd;
foreach ($rd as $k1=>$v1)
{
$r[$k]["body"][$v1["st_id"]]["body"][$v1["kat_id"]]=$v1;
}
}

}

$smarty->assign('pd', $r);

$sql = rtrim(file_get_contents('sql/bud_ru_cash_out_detail_total.sql'));
$sql=stritr($sql,$p);
$r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pdt', $r);


$smarty->display('bud_ru_cash_out_detail.html');
?>