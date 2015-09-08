<?
audit("открыл справочник типов активностей");
if (isset($_REQUEST["save"]))
{
	$table_name = 'p_activ_types';
	foreach ($_REQUEST["item"] as $key=>$val)
	{
		$fields_values = array('name'=>$val);
		$affectedRows = $db->extended->autoExecute($table_name, $fields_values, MDB2_AUTOQUERY_UPDATE, 'id='.$key);
		if (PEAR::isError($affectedRows)) { echo $affectedRows->getMessage(); }
	}
	audit("сохранил справочник типов активностей");
}
if (isset($_REQUEST["add"]))
{
	$table_name = 'p_activ_types';
	$fields_values = array("name"=>$_REQUEST["new_item"]);
	$affectedRows = $db->extended->autoExecute($table_name, $fields_values, MDB2_AUTOQUERY_INSERT);
	if (PEAR::isError($affectedRows)) { echo $affectedRows->getMessage(); }
	audit("добавил новый тип активности");
}
if (isset($_REQUEST["delete"]))
{
	foreach ($_REQUEST["del"] as $key=>$val)
	{
		$table_name = 'p_activ_types';
		$affectedRows = $db->extended->autoExecute($table_name, null, MDB2_AUTOQUERY_DELETE, 'id='.$key);
		if (PEAR::isError($affectedRows)) { echo $affectedRows->getMessage(); }
		audit("удалил тип активности");
	}
}
$sql = rtrim(file_get_contents('sql/activ_types.sql'));
$activ_types = &$db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$smarty->assign('activ_types', $activ_types);
$smarty->display('activ_types.html');
?>