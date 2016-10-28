<?

$sql=rtrim(file_get_contents('sql/main_box_dm.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$x=array();
foreach ($data as $k=>$v)
{
$x[$v["id"]]["head"]=$v;
$x[$v["id"]]["chat"][$v["cid"]]=$v;
$x[$v["id"]]["files"][]=$v["fn"];
}
$smarty->assign('box_dm', $x);
//print_r($x);

$sql=rtrim(file_get_contents('sql/main_box_dm_creator.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$x=array();
foreach ($data as $k=>$v)
{
$x[$v["id"]]["head"]=$v;
$x[$v["id"]]["chat"][$v["cid"]]=$v;
$x[$v["id"]]["files"][]=$v["fn"];
}
$smarty->assign('box_dm_creator', $x);
//print_r($x);

$sql = rtrim(file_get_contents('sql/dm_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dm_list', $data);

$sql = rtrim(file_get_contents('sql/main_box_dm_fil_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('fil_list', $data);

$sql = rtrim(file_get_contents('sql/dm_cat_appeals.sql'));
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dm_cat_appeals', $r);

?>