<?



InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
InitRequestVar("acceptor_list",0);

$params=array(':dpt_id' => $_SESSION["dpt_id"],
	':tn'=>$tn,
	":dates_list1"=>"'".$_REQUEST["dates_list1"]."'",
	":dates_list2"=>"'".$_REQUEST["dates_list2"]."'",
	':acceptor_list' => $_REQUEST["acceptor_list"]
);

$sql = rtrim(file_get_contents('sql/ol_stat_acceptor_list.sql'));
$sql=stritr($sql,$params);
$acceptor_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('acceptor_list', $acceptor_list);

$sql=rtrim(file_get_contents('sql/ol_stat_head.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

$smarty->assign('ol_stat', $data);

$smarty->display('ol_stat.html');

?>