<?php


audit("вошел в замену СВМС");

if (isset($_REQUEST["replace"]))
{
	if (($_REQUEST["replace_svms"]["svms_from"]!='')&&($_REQUEST["replace_svms"]["svms_to"]!=''))
	{
	//ses_req();

	$from=$_REQUEST["replace_svms"]["svms_from"];
	$to=$_REQUEST["replace_svms"]["svms_to"];

	audit("заменил СВМС ".$from." на ".$to."");

	$table_name = "routes_head";
	$keys = array('tn'=>$from);
	$values = array('tn'=>$to);
	Table_Update ($table_name, $keys, $values);

	$db->query("DELETE FROM svms_oblast WHERE oblast IN (SELECT oblast FROM svms_oblast WHERE tn = ".$from.") and tn=".$to);
	$table_name = "svms_oblast";
	$keys = array('tn'=>$from);
	$values = array('tn'=>$to);
	Table_Update ($table_name, $keys, $values);

	}
}




$sql = rtrim(file_get_contents('sql/svms_list.sql'));
$p = array(":tn"=>$tn,':dpt_id'=>$_SESSION['dpt_id']);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('svms', $data);




$smarty->display('replace_svms.html');



?>