<?




$params=array(
	':dpt_id' => $_SESSION["dpt_id"],
	':id' => $_REQUEST["id"]
);




$sql = rtrim(file_get_contents('sql/bud_svod_zp_ag_get_val.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('x', $x);




//print_r($x);


$smarty->display('bud_svod_zp_ag_get_val.html');





?>