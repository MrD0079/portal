<?

audit ("открыл форму редактирования заявки на тренинг","tr");



$p = array();
$p[':id'] = $_REQUEST["id"];

if (isset($_REQUEST["SendNBT"])&&isset($_REQUEST["table"]))
{
	$order = $_REQUEST["id"];
	if (isset($_REQUEST["text"]))
	{
		$keys = array("id" => $order);
		$vals = array(
			"text" => $_REQUEST["text"]
		);
		Table_Update("dc_order_head",$keys,$vals);
	}
	foreach ($_REQUEST["table"] as $k => $v)
	{
	$keys = array(
		"head" => $order,
		"tn" => $v["tn"]
	);
	$vals = array(
		"manual" => $v["manual"]
	);
	Table_Update("dc_order_body",$keys,$vals);
	}
}

$smarty->assign('text', $db->getOne("select text from dc_order_head where id=".$_REQUEST["id"]));

$sql=rtrim(file_get_contents('sql/dc_order_edit_users.sql'));
$sql=stritr($sql,$p);
//echo $sql;
$tru = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tru', $tru);

$sql = rtrim(file_get_contents('sql/dc_order_edit_users_add.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('trua', $data);

$sql = rtrim(file_get_contents('sql/dc_order_edit_users_add_1.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('trub', $data);

//print_r($data);

$smarty->display('dc_order_edit.html');

?>