<?php

$sql=rtrim(file_get_contents('sql/bud_replace_ts.sql'));
$bud_replace_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_replace_ts', $bud_replace_ts);

if (isset($_REQUEST["replace"])&&($_REQUEST["from"]!='')&&($_REQUEST["to"]!=''))
{
	$from['tn']=$_REQUEST["from"];
	$from['tab_num']=$db->GetOne('select tab_num from user_list where tn='.$_REQUEST["from"]);
	$from['tstabnum']=$db->GetOne('select tab_num from user_list where tn='.$_REQUEST["from"]);
	$to['tn']=$_REQUEST["to"];
	$to['tab_num']=$db->GetOne('select tab_num from user_list where tn='.$_REQUEST["to"]);
	$to['tstabnum']=$db->GetOne('select tab_num from user_list where tn='.$_REQUEST["to"]);
	//print_r($a);
	//print_r($from);
	//print_r($to);
	foreach ($bud_replace_ts as $k => $v)
	{
			$keys=array($v['field_name']=>$from[$v['field_name']]);
			$vals=array($v['field_name']=>$to[$v['field_name']]);
			/*echo "*************************<br><pre>";
			echo $v['table_name']."<br>";
			print_r($keys);
			print_r($vals);
			echo "</pre>*************************<br>";*/
			$sql='update '.$v['table_name'].' set '.$v['field_name'].'='.$to[$v['field_name']].' where '.$v['field_name'].'='.$from[$v['field_name']];
			$db->query($sql);
			//echo $sql."<br>";
			//Table_Update($v['table_name'],$keys,$vals);
	}
}

$sql=rtrim(file_get_contents('sql/bud_replace_ts_list.sql'));
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);

$smarty->display('bud_replace_ts.html');

?>