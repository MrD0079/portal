<?

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("fil",0);
InitRequestVar("clusters",0);
InitRequestVar("sd",$_SESSION["month_list"]);
InitRequestVar("ed",$_SESSION["month_list"]);
InitRequestVar("funds",0);
InitRequestVar("db",0);
InitRequestVar("st",0);
InitRequestVar("sort",1);
InitRequestVar("tp_kod",0);

$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':sd' => "'".$_REQUEST["sd"]."'",
	':ed' => "'".$_REQUEST["ed"]."'",
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
	':fil' => $_REQUEST["fil"],
	':clusters' => $_REQUEST["clusters"],
	':funds'=>$_REQUEST["funds"],
	':db' => $_REQUEST["db"],
	':st' => $_REQUEST["st"],
	':sort' => $_REQUEST["sort"],
	':tp_kod' => $_REQUEST["tp_kod"],
);

if ($_REQUEST["tp_kod"]!=0)
{
	$sql=rtrim(file_get_contents('sql/bud_svod_zat_tp_list_find.sql'));
	$sql=stritr($sql,$params);
	$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	if (isset($data))
	{
		$smarty->assign('find_tp', $data);
	}
}

$sql = rtrim(file_get_contents('sql/bud_svod_zat_tp_list.sql'));
$sql=stritr($sql,$params);
$xx = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('xx', $xx);

$sql = rtrim(file_get_contents('sql/bud_svod_zat_tp_list_total.sql'));
$sql=stritr($sql,$params);
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_total', $x);

$smarty->display('bud_svod_zat_tp_list.html');

?>