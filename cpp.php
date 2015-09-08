<?php




InitRequestVar("flt_tz_oblast","");
InitRequestVar("flt_id_net",0);

//ses_req();


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
		Table_update("cpp",array("id"=>0),array("id_net"=>0));
		$new_id = &$db->getOne("SELECT max(id) FROM cpp");
		$_REQUEST["id"]=$new_id;
		$_POST["id"]=$new_id;
	}
}

if (isset($_REQUEST["edit"]))
{
	audit("изменил параметры ТЗ ".$_REQUEST["edit_id"]);
	$table_name = 'cpp';
	$fields_values = $_REQUEST["edit"];
	$affectedRows = $db->extended->autoExecute($table_name, $fields_values, MDB2_AUTOQUERY_UPDATE, 'id='.$_REQUEST["edit_id"]);
	if (PEAR::isError($affectedRows)) { echo $affectedRows->getMessage(); }
}

$sql=rtrim(file_get_contents('sql/cpp.sql'));
$params=array(':tn'=>$tn,':flt_tz_oblast'=>"''",':flt_id_net'=>0);
$sql=stritr($sql,$params);
$cpp_all = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('cpp_all', $cpp_all);

$sql=rtrim(file_get_contents('sql/cpp.sql'));
$params=array(':tn'=>$tn,':flt_tz_oblast'=>"'".$_REQUEST["flt_tz_oblast"]."'",':flt_id_net'=>$_REQUEST["flt_id_net"]);
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