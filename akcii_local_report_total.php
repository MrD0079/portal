<?



InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("ok_selected",1);

$params=array(
	':z_id' => $_REQUEST["z_id"],
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
	':ok_selected' => $_REQUEST["ok_selected"],
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
);

$sql = rtrim(file_get_contents('sql/akcii_local_report_sales_total.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('total', $x);

$smarty->display('akcii_local_report_total.html');

?>