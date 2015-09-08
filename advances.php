<?
InitRequestVar("sd",$next1);
InitRequestVar("ed",$next1);
InitRequestVar("full","me");

$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':sd' => "'".$_REQUEST["sd"]."'",
	':ed' => "'".$_REQUEST["ed"]."'",
	':full' => "'".$_REQUEST["full"]."'",
);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$sql=stritr($sql,$params);
$dt = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dt', $dt);

$sql=rtrim(file_get_contents('sql/advances.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('advances', $data);

$sql=rtrim(file_get_contents('sql/advances_total.sql'));
$sql=stritr($sql,$params);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('total', $data);

$smarty->display('advances.html');

?>