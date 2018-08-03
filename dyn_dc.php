<?



audit("открыл dyn_dc","dyn_dc");

InitRequestVar("k");
InitRequestVar("d");

$sql = rtrim(file_get_contents('sql/os_user_list.sql'));
//echo $sql;
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('os_user_list', $res);

if ($_REQUEST["k"]["tn"]!=''&&$_REQUEST["k"]["y"]!='')

{
$sql = rtrim(file_get_contents('sql/dyn_dc_head.sql'));
$p = array(':tn' => $_REQUEST["k"]["tn"],':y'=>$_REQUEST["k"]["y"]);
$sql=stritr($sql,$p);
//echo $sql;
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('os_head', $res);

//print_r($res);

//print_r($res);


//for ($i=0;$i<2;$i++)
//{
$sql = rtrim(file_get_contents('sql/dyn_dc_body.sql'));
$p = array(':tn' => $_REQUEST["k"]["tn"],':y'=>$_REQUEST["k"]["y"]/*-$i*/);
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('os_body'/*.$i*/, $res);
//}


//print_r($res);


}

$smarty->display('dyn_dc.html');

?>