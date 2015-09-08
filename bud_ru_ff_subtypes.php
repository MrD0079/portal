<?





$sql=rtrim(file_get_contents('sql/bud_ru_ff_subtypes.sql'));
$params=array(':dpt_id' => $_SESSION["dpt_id"]);
$params[":tn"]=$tn;
$sql=stritr($sql,$params);
$bud_ru_ff_subtypes = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_ru_ff_subtypes', $bud_ru_ff_subtypes);

/*
$sql=$db->getOne('select get_list from bud_ru_ff_subtypes where id='.$v['subtype']);
$sql=stritr($sql,$params);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$st[$k]['list'] = $list;
*/

$smarty->display('bud_ru_ff_subtypes.html');


?>