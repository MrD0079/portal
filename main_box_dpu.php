<?

$sql=rtrim(file_get_contents('sql/main_box_dpu.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$x=array();
foreach ($data as $k=>$v)
{
$x[$v["id"]]["head"]=$v;
$x[$v["id"]]["chat"][$v["cid"]]=$v;
}
$smarty->assign('box_dpu', $x);

$sql=rtrim(file_get_contents('sql/main_box_dpu_creator.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$x=array();
foreach ($data as $k=>$v)
{
$x[$v["id"]]["head"]=$v;
$x[$v["id"]]["chat"][$v["cid"]]=$v;
}
$smarty->assign('box_dpu_creator', $x);

?>