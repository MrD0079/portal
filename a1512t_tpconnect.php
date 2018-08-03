<?php

if (isset($_REQUEST["new"])) {
	Table_Update("A1512T_XLS_TPCLIENT",$_REQUEST["add"],$_REQUEST["add"]);
}
if (isset($_REQUEST["del"])) {
	foreach ($_REQUEST["del"] as $key => $val) {
		$a = explode(",", $val);
		$params = array(
			'h_client' => $a[0],
			'tp_kod' => $a[1]
		);
		Table_Update("A1512T_XLS_TPCLIENT",$params,null);
	}
}
InitRequestVar("filter_h_client");
InitRequestVar("exp_list_without_ts",0);
$p = array(
	":dpt_id" => $_SESSION["dpt_id"],
	":filter_h_client" => "'".$_REQUEST["filter_h_client"]."'",
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
);
$sql = rtrim(file_get_contents('sql/a1512t_tpconnect.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('emp_exp', $data);
$sql = rtrim(file_get_contents('sql/a1512t_client.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('client', $data);
$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);
$smarty->display('a1512t_tpconnect.html');
?>