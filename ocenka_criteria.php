<?php

audit("вошел в список критериев с типом ".$_REQUEST["type"]);

include "ocenka_events.php";


if (isset($_REQUEST["new"])) {
	$sql = "insert into ocenka_criteria (type,pos,name,description,num,weight,parent,event) values (?,?,?,?,?,?,?,?)";
	$params = $_REQUEST["add"];
	foreach ($params as $key=>$val)
	{
		$params[$key]=stripslashes($val);
	}
	$table_name = 'ocenka_criteria';
	$fields_values = $params;
	$affectedRows = $db->extended->autoExecute($table_name, $fields_values, MDB2_AUTOQUERY_INSERT);
	if (PEAR::isError($affectedRows)) { echo $affectedRows->getMessage(); }
	audit("добавил критерий в список критериев");
}

if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $key=>$val)
	{
		$table_name = 'ocenka_criteria';
		$affectedRows = $db->extended->autoExecute($table_name, null, MDB2_AUTOQUERY_DELETE, 'id_num='.$key);
		if (PEAR::isError($affectedRows)) { echo $affectedRows->getMessage(); }
		audit("удалил критерий из списка критериев");
	}
}

if (isset($_REQUEST["upd"]))
{
	$keys=array("id_num"=>$_REQUEST["add"]["id_num"]);
	$vals=$_REQUEST["add"];
	Table_Update("ocenka_criteria",$keys,$vals);
	audit("обновил критерий в списке критериев");
}

$sql=rtrim(file_get_contents('sql/pos_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos_list', $data);

isset($_REQUEST["id"])?$id=$_REQUEST["id"]:$id=0;

$sql = rtrim(file_get_contents('sql/ocenka_criteria.sql'));
$params=array($_REQUEST["event"],$_REQUEST["type"],$id);
$data = $db->getAll($sql, null, $params, null, MDB2_FETCHMODE_ASSOC);



//print_r($data);

$smarty->assign('criteria', $data);

if (isset($_REQUEST["edit"]))
{
	foreach ($data as $k=>$v)
	{
		if ($v["id_num"]==$_REQUEST["edit"])
		{
			$smarty->assign('edit', $v);
		}
	}
}

$smarty->display('ocenka_criteria.html');

?>