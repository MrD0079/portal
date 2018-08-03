<?



//InitRequestVar("dt",$now);



$params=array(
	":head"=>$_REQUEST["head"]
);

$sql = rtrim(file_get_contents('sql/beg_visit2_to.sql'));
$sql=stritr($sql,$params);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);


//foreach ($list as $k=>$v)

/*$params=array(
	':parent_id'=>$parent_id
);
$sql = rtrim(file_get_contents('sql/beg_visit2_to_f_'.$_SESSION["cnt_kod"].'.sql'));
$sql=stritr($sql,$params);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);
$smarty->display('beg_visit_2_to_f_save.html');
*/




//print_r($list);

$smarty->display('beg_visit_2_to.html');

?>