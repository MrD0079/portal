<?
InitRequestVar("sd",$now1);
InitRequestVar("ed",$now);
InitRequestVar("creator",0);


$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':sd' => "'".$_REQUEST["sd"]."'",
	':ed' => "'".$_REQUEST["ed"]."'",
	':creator' => $_REQUEST["creator"],
);

$sql = rtrim(file_get_contents('sql/spd_list.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('creator', $exp_list_without_ts);

$sql=rtrim(file_get_contents('sql/box_reestr.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$x=array();
foreach ($data as $k=>$v)
{
$x[$v["id"]]["head"]=$v;
$x[$v["id"]]["chat"][$v["cid"]]=$v;
}
$smarty->assign('box', $x);

$smarty->display('box_reestr.html');

?>