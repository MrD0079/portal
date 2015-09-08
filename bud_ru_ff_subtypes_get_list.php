<?

$params=array(':dpt_id' => $_SESSION["dpt_id"]);
$params[":tn"]=$tn;

$sql=$db->getOne('select get_list from bud_ru_ff_subtypes where id='.$_REQUEST['subtype']);
$sql=stritr($sql,$params);

//echo $sql;

$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);

$smarty->display('bud_ru_ff_subtypes_get_list.html');

?>