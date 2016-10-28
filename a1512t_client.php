<?php
//ses_req();
if (isset($_REQUEST["new"])) {
	Table_Update("A1512T_XLS_SALESPLAN",$_REQUEST["add"],$_REQUEST["add"]);
}
if (isset($_REQUEST["del"])) {
	foreach ($_REQUEST["del"] as $key => $val) {
		$keys = array(
			'h_client' => $val
		);
		Table_Update("A1512T_XLS_SALESPLAN",$keys,null);
	}
}
if (isset($_REQUEST["save"])) {
	foreach ($_REQUEST["clients"] as $key => $val) {
		$keys = array(
			'h_client' => $key
		);
		Table_Update("A1512T_XLS_SALESPLAN",$keys,$val);
	}
}
$sql = rtrim(file_get_contents('sql/a1512t_client.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('clients', $data);
$smarty->display('a1512t_client.html');
?>