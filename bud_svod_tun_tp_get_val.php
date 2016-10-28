<?

$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':dt' => "'".$_REQUEST["dt"]."'",
//	':tp_kod' => "'".$_REQUEST["tp_kod"]."'",
);


if (strpos($_REQUEST["key"],"_")===false)
{
	$params[":tp_kod"]=$_REQUEST["key"];
	$sql = rtrim(file_get_contents('sql/bud_svod_tun_tp_get_val.sql'));
}
else
{
	$keys = split("_",$_REQUEST["key"]);
	$params[":net_kod"]=$keys[0];
	$params[":db"]=$keys[1];
	//$params[":fil"]=$keys[2];
	$sql = rtrim(file_get_contents('sql/bud_svod_tun_tpn_get_val.sql'));
}

$sql=stritr($sql,$params);
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('x', $x);

$smarty->display('bud_svod_tun_tp_get_val.html');

?>