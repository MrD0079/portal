<?php
InitRequestVar("flt_tz_oblast","");
InitRequestVar("flt_id_net",0);
audit("вошел в список ТЗ");
if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_update("cpp",array("id"=>$v),null);
	}
}
if (isset($_REQUEST["id"]))
{
	if($_REQUEST["id"]==0)
	{
		$new_id = get_new_id();
		$_REQUEST["id"]=$new_id;
		$_POST["id"]=$new_id;
	}
	else
	{
		$sql=rtrim(file_get_contents('sql/cpp.sql'));
		$params=array(':tn'=>$tn,':flt_tz_oblast'=>"'".$_REQUEST["flt_tz_oblast"]."'",':flt_id_net'=>$_REQUEST["flt_id_net"],':id'=>$_REQUEST["id"]);
		$sql=stritr($sql,$params);
		$cpp = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('cpp_one', $cpp);
	}
}
if (isset($_REQUEST["edit"]))
{
	audit("изменил параметры ТЗ ".$_REQUEST["edit_id"]);
	Table_update("cpp",array("id"=>$_REQUEST["edit_id"]),$_REQUEST["edit"]);
}
$sql=rtrim(file_get_contents('sql/cpp.sql'));
$params=array(':tn'=>$tn,':flt_tz_oblast'=>"'".$_REQUEST["flt_tz_oblast"]."'",':flt_id_net'=>$_REQUEST["flt_id_net"],':id'=>0);
$sql=stritr($sql,$params);
$cpp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('cpp', $cpp);
$sql=rtrim(file_get_contents('sql/ms_nets.sql'));
$nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $nets);
$sql=rtrim(file_get_contents('sql/cpp_oblast.sql'));
$oblast = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('oblast', $oblast);
$smarty->display('cpp.html');
?>