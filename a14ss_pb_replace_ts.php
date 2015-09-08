<?php

audit("вошел в замену ТС");

if (isset($_REQUEST["replace"])&&($_REQUEST["from"]!='')&&($_REQUEST["to"]!=''))
{



	$from['tn']=$_REQUEST["from"];
	$from['tab_num']=$db->GetOne('select tab_num from user_list where tn='.$_REQUEST["from"]);
	$to['tn']=$_REQUEST["to"];
	$to['tab_num']=$db->GetOne('select tab_num from user_list where tn='.$_REQUEST["to"]);
	audit("заменил ТС ".$_REQUEST["from"]." на ".$_REQUEST["to"]." в таблице планов/бонусов акции шоколадный сезон");
	$sql='update a14ss_pb set tab_num='.$to['tab_num'].' where tab_num='.$from['tab_num'];
	$db->query($sql);
}

$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=rtrim(file_get_contents('sql/replace_ts_list.sql'));
$sql=stritr($sql,$p);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);

$smarty->display('a14ss_pb_replace_ts.html');

?>