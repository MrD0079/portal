<?



//InitRequestVar("dt",$now);



$params=array(
	":head"=>$_REQUEST["head"]
);

$sql = rtrim(file_get_contents('sql/beg_visit2_head.sql'));
$sql=stritr($sql,$params);
$head = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('head', $head);


//print_r($head);


$smarty->display('beg_visit_2_head.html');

?>