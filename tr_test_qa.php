<?php
InitRequestVar("tr",0);
audit("вошел в список критериев теста тренинга ".$_REQUEST["tr"]);
include "tr_test_qa_tr.php";

if (isset($_REQUEST["add_a"])) {
	audit("добавил ответы в список теста тренинга ".$_REQUEST["tr"]);
	foreach ($_REQUEST["add_a"] as $k=>$v)
	{
		$keys=array('id_num'=>0,'type'=>6,'tr'=>$_REQUEST["tr"],'parent'=>$k);
		Table_Update("tr_test_qa",$keys,$keys);
	}
}

if (isset($_REQUEST["add_q"])) {
	$keys=array('id_num'=>0,'type'=>5,'tr'=>$_REQUEST["tr"]);
	Table_Update("tr_test_qa",$keys,$keys);
	audit("добавил вопрос в список теста тренинга ".$_REQUEST["tr"]);
}


if (isset($_REQUEST["save"])&&isset($_REQUEST["a"]))
{
	audit("обновил критерии в списке теста тренинга ".$_REQUEST["tr"]);
	foreach ($_REQUEST["a"] as $k=>$v)
	{
		$keys=array("id_num"=>$k);
		$vals=$v;
		Table_Update("tr_test_qa",$keys,$vals);
	}
}

if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $key=>$val)
	{
		$table_name = 'tr_test_qa';
		$affectedRows = $db->extended->autoExecute($table_name, null, MDB2_AUTOQUERY_DELETE, 'id_num='.$key);
		if (PEAR::isError($affectedRows)) { echo $affectedRows->getMessage(); }
		audit("удалил критерий из списка теста тренинга ".$_REQUEST["tr"]);
	}
}

$params=array(":tr"=>$_REQUEST["tr"]);
$sql = rtrim(file_get_contents('sql/tr_test_qa.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($data as $k=>$v)
{
	$d[$v["q_id"]]["head"]=$v;
	if ($v["a_id"]!='')
	{
		$d[$v["q_id"]]["data"][$v["a_id"]]=$v;
	}
}
isset($d)?$smarty->assign('tr_test_qa', $d):null;

$smarty->display('tr_test_qa.html');

?>