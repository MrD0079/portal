<?


if (isset($_REQUEST["save"]))
{
//ses_req();
Table_update("pos_msg",array("pos_id"=>$_REQUEST["dolgn_msg"]),array("pos_msg"=>addslashes($_REQUEST["msg"])));
}


$sql=rtrim(file_get_contents('sql/dolgn_msg.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dolgn_msg', $data);

$smarty->display('inform.html');


?>