<?


$id=get_new_id();


$keys = array(
	'id'=>$id,
	'tn'=>$tn,
	'unscheduled'=>1,
	'dpt_id' => $_SESSION["dpt_id"],
	'dt'=>OraDate2MDBDate($_REQUEST['dt'])
);

Table_Update('bud_svod_zp', $keys,$keys);

$smarty->assign('id',$id);


$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':dt' => "'".$_REQUEST["dt"]."'",
);


$sql = rtrim(file_get_contents('sql/bud_svod_zp_ag_fil_list.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('fil_list', $x);



$smarty->display('bud_svod_zp_ag_unsheduled_new.html');


?>