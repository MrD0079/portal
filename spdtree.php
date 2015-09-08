<?


InitRequestVar("all",1);


$sql=rtrim(file_get_contents('sql/spdtree.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"],':flt'=>$_REQUEST["all"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spdtree', $data);

//echo $sql;
//print_r($data);

$smarty->display('spdtree.html');

?>