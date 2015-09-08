<?

InitRequestVar("dt",$now);

/*


$params=array(':dpt_id' => $_SESSION["dpt_id"],
	":tn"=>$tn,
	":dt"=>"'".$_REQUEST["dt"]."'",
);
*/




$params=array(':dpt_id' => $_SESSION["dpt_id"],
	":tn"=>$tn,
	":dt"=>"'".$_REQUEST["dt"]."'"
);

$sql = rtrim(file_get_contents('sql/beg_visit_visit_list.sql'));
$sql=stritr($sql,$params);
$visit_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('visit_list', $visit_list);









$smarty->display('beg_visit.html');

?>