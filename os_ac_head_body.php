<?



$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);

$sql = rtrim(file_get_contents('sql/ac_head.sql'));
//$p = array(':tn' => $_REQUEST["k"]["tn"],':y'=>$_REQUEST["k"]["y"]);
$p = array(':id' => $_REQUEST['ac_id']);
$sql=stritr($sql,$p);
//echo $sql;
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ac_head', $res);

//print_r($res);





$sql = rtrim(file_get_contents('sql/os_ac_memb_head.sql'));
$p = array(
':ac_memb_id' => $_REQUEST['id'],
);
$sql=stritr($sql,$p);
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('os_ac_memb_head', $res);





$sql = rtrim(file_get_contents('sql/os_ac_head.sql'));
//$p = array(':tn' => $_REQUEST["k"]["tn"],':y'=>$_REQUEST["k"]["y"]);
$p = array(
':ac_memb_id' => $_REQUEST['id'],
':ac_memb_type' => "'".$_REQUEST['ie']."'"
);
$sql=stritr($sql,$p);
//echo $sql;
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('os_ac_head', $res);



//print_r($res);


$head_id=$res["id"];















//print_r($res);

$sql = rtrim(file_get_contents('sql/os_ac_body.sql'));
//$p = array(':tn' => $_REQUEST["k"]["tn"],':y'=>$_REQUEST["k"]["y"]);
$p = array(
':ac_memb_id' => $_REQUEST['id'],
':ac_memb_type' => "'".$_REQUEST['ie']."'"
);
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('os_ac_body', $res);
//print_r($res);




$sql=rtrim(file_get_contents('sql/os_ac_goal.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('os_ac_goal', $data);


$smarty->display('os_ac_head_body.html');




?>