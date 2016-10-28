<?
$params=array(':dpt_id' => $_SESSION["dpt_id"]);
$params[":tn"]=$tn;
$autocomplete=$db->getOne('SELECT ff.autocomplete FROM BUD_RU_FF_SUBTYPES ffst, BUD_RU_FF ff WHERE ffst.id = ff.subtype and ff.id='.$_REQUEST['subtype']);
$smarty->assign('autocomplete', $autocomplete);
if ($autocomplete==1)
{
	if ($_REQUEST['item']!=null){
		$sql=$db->getOne('SELECT ffst.get_item FROM BUD_RU_FF_SUBTYPES ffst, BUD_RU_FF ff WHERE ffst.id = ff.subtype and ff.id='.$_REQUEST['subtype']);
		$params[":id"]=$_REQUEST['item'];
		$sql=stritr($sql,$params);
		$item_name = $db->getOne($sql);
		$smarty->assign('item_name', $item_name);
	}	
}
else
{
	//$sql=$db->getOne('select get_list from bud_ru_ff_subtypes where id='.$_REQUEST['subtype']);
	$sql=$db->getOne('SELECT ffst.get_list FROM BUD_RU_FF_SUBTYPES ffst, BUD_RU_FF ff WHERE ffst.id = ff.subtype and ff.id='.$_REQUEST['subtype']);
	$sql=stritr($sql,$params);
	//echo $sql;
	$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('list', $list);
}
$smarty->display('bud_ru_ff_subtypes_get_list.html');
?>