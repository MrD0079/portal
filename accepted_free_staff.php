<?
if (isset($_REQUEST["del"])) {
	Table_Update('free_staff', array("id"=>$_REQUEST['del']),null);
} else {
	if (isset($_REQUEST["generate"])) {
		InitRequestVar("sd");
		InitRequestVar("ed");
		InitRequestVar("pos",0);
		InitRequestVar("seat",0);
		$sql=rtrim(file_get_contents('sql/accepted_free_staff.sql'));
		$p = array(
			':sd'=>"'".$_REQUEST["sd"]."'",
			':ed'=>"'".$_REQUEST["ed"]."'",
			':pos_id'=>$_REQUEST["pos"],
			':seat'=>$_REQUEST["seat"],
			':tn'=>$tn,
			':staff_fio'=>"'".$_REQUEST["staff_fio"]."'",
			':dpt_id' => $_SESSION["dpt_id"]
		);
		$sql=stritr($sql,$p);
		//echo $sql;
		$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('free_staff', $data);
	}
	$sql=rtrim(file_get_contents('sql/dolgn_list.sql'));
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('dolgn_list_all', $data);
	$sql=rtrim(file_get_contents('sql/free_staff_seat.sql'));
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('seat', $data);
	$smarty->display('accepted_free_staff.html');
}
?>