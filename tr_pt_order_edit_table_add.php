<?

$p = array();
$p[':id'] = $_REQUEST["id"];
$p[':dpt_id'] = $_SESSION["dpt_id"];
$p[':h_eta'] = "'".$_REQUEST["h_eta"]."'";

$smarty->assign('completed', $db->getOne("select completed from tr_pt_order_head where id=".$_REQUEST["id"]));

$sql = rtrim(file_get_contents('sql/tr_pt_order_edit_users_add.sql'));
$sql=stritr($sql,$p);
//echo $sql;
//exit;
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('trua', $data);

$smarty->display('tr_pt_order_edit_table_add.html');

?>