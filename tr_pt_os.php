<?

audit ("открыл форму обратной связи по тренингу","tr");



$p = array();

$p[':h_eta'] = "'".$_SESSION["h_eta"]."'";

$sql=rtrim(file_get_contents('sql/tr_pt_os_get_id.sql'));
$sql=stritr($sql,$p);
$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

if ($d)
{
	$id=$d["id"];
	isset($_REQUEST["saveOS"])&&isset($_REQUEST["os"])&&isset($id) ? Table_Update("tr_pt_order_body",array("head"=>$id,"h_eta"=>$_SESSION["h_eta"]),$_REQUEST["os"]) : null;

	$sql=rtrim(file_get_contents('sql/tr_pt_os_get_tr.sql'));
	$sql=stritr($sql,$p);
	$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('d', $d);

	$p[':id'] = $id;
	$sql=rtrim(file_get_contents('sql/tr_pt_list_order.sql'));
	$sql=stritr($sql,$p);
	$h = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('h', $h);
}

$smarty->display('tr_pt_os.html');

?>