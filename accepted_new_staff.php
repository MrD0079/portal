<?


$sql=rtrim(file_get_contents('sql/dolgn_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dolgn_list_all', $data);



if (isset($_REQUEST["generate"]))
{

InitRequestVar("sd");
InitRequestVar("ed");
InitRequestVar("pos",0);

/*
!isset($_REQUEST["pos"]) ? $_REQUEST["pos"]=0: null;
isset($_REQUEST["sd"]) ? $_SESSION["sd"]=$_REQUEST["sd"]: null;
isset($_REQUEST["ed"]) ? $_SESSION["ed"]=$_REQUEST["ed"]: null;
isset($_REQUEST["pos"]) ? $_SESSION["pos"]=$_REQUEST["pos"]: null;
*/




$sql=rtrim(file_get_contents('sql/accepted_new_staff.sql'));
$p = array(
	':sd'=>"'".$_REQUEST["sd"]."'",
	':ed'=>"'".$_REQUEST["ed"]."'",
	':pos_id'=>$_REQUEST["pos"],
	':tn'=>$tn,
	':dpt_id' => $_SESSION["dpt_id"]
);
$sql=stritr($sql,$p);
//echo $sql;
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('new_staff', $data);

}


$smarty->display('accepted_new_staff.html');

?>