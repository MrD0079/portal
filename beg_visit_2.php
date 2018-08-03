<?



InitRequestVar("dt",$now);



$params=array(':dpt_id' => $_SESSION["dpt_id"],
	":tn"=>$tn,
	":tp_kod"=>$_REQUEST["tp_kod"],
	":dt"=>"'".$_REQUEST["dt"]."'",
);

$keys = array("tn"=>$tn,'tp_kod'=>$_REQUEST['tp_kod'],'dt'=>OraDate2MDBDate($_REQUEST['dt']));
Table_Update('beg_visit_head', $keys,$keys);

$sql = rtrim(file_get_contents('sql/beg_visit2_head_id.sql'));
$sql=stritr($sql,$params);
$head = $db->getOne($sql);
$smarty->assign('head', $head);

$params=array(':head'=>$head);

$sql = rtrim(file_get_contents('sql/beg_visit2_groups.sql'));
$gr_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('gr_list', $gr_list);

$sql = rtrim(file_get_contents('sql/beg_visit2_tpname.sql'));
$sql=stritr($sql,$params);
$tpname = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tpname', $tpname);

$smarty->display('beg_visit_2.html');

?>