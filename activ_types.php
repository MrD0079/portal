<?
audit("открыл справочник типов активностей");
if (isset($_REQUEST["save"]))
{
	$table_name = 'p_activ_types';
	foreach ($_REQUEST["item"] as $key=>$val)
	{
		$fields_values = array('name'=>$val);
                Table_Update($table_name, array('id'=>$key), $fields_values);
	}
	audit("сохранил справочник типов активностей");
}
if (isset($_REQUEST["add"]))
{
	$table_name = 'p_activ_types';
	$fields_values = array("name"=>$_REQUEST["new_item"]);
        Table_Update($table_name, $fields_values, $fields_values);
}
if (isset($_REQUEST["delete"]))
{
	foreach ($_REQUEST["del"] as $key=>$val)
	{
		$table_name = 'p_activ_types';
		Table_Update($table_name, array('id'=>$key),null);
	}
}
$sql = rtrim(file_get_contents('sql/activ_types.sql'));
$activ_types = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$smarty->assign('activ_types', $activ_types);
$smarty->display('activ_types.html');
?>