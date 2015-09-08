<?

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("fil",0);
InitRequestVar("clusters",0);
InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
InitRequestVar("db",0);
InitRequestVar("adminid8",1);

$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':sd' => "'".$_REQUEST["dates_list1"]."'",
	':ed' => "'".$_REQUEST["dates_list2"]."'",
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
	':fil' => $_REQUEST["fil"],
	':clusters' => $_REQUEST["clusters"],
	':db' => $_REQUEST["db"],
	':adminid8' => $_REQUEST["adminid8"],
);

$sql = rtrim(file_get_contents('sql/to_money_list.sql'));
$sql=stritr($sql,$params);
$xx = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('xx', $xx);

$sql = rtrim(file_get_contents('sql/to_money_list_total.sql'));
$sql=stritr($sql,$params);
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_total', $x);

$smarty->display('to_money_list.html');

?>