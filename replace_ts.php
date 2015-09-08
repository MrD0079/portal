<?php

audit("вошел в замену ТС");

$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=rtrim(file_get_contents('sql/replace_ts.sql'));
$sql=stritr($sql,$p);
$replace_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('replace_ts', $replace_ts);

if (isset($_REQUEST["replace"])&&($_REQUEST["from"]!='')&&($_REQUEST["to"]!=''))
{
	$p[':tn_from'] = $_REQUEST["from"];
	$p[':tn_to'] = $_REQUEST["to"];
	$sql=rtrim(file_get_contents('sql/replace_ts_run.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$db->query($sql);
	//$db->query('BEGIN pr_replace_ts ('.$_REQUEST["from"].', '.$_REQUEST["to"].', '.$_SESSION["dpt_id"].'); END;');
	/*
	$from['tn']=$_REQUEST["from"];
	$from['tab_num']=$db->GetOne('select tab_num from user_list where tn='.$_REQUEST["from"]);
	$from['tstabnum']=$db->GetOne('select tab_num from user_list where tn='.$_REQUEST["from"]);
	$from['ts_tab_num']=$db->GetOne('select tab_num from user_list where tn='.$_REQUEST["from"]);
	$to['tn']=$_REQUEST["to"];
	$to['tab_num']=$db->GetOne('select tab_num from user_list where tn='.$_REQUEST["to"]);
	$to['tstabnum']=$db->GetOne('select tab_num from user_list where tn='.$_REQUEST["to"]);
	$to['ts_tab_num']=$db->GetOne('select tab_num from user_list where tn='.$_REQUEST["to"]);
	//print_r($a);
	//print_r($from);
	//print_r($to);
	audit("заменил ТС ".$_REQUEST["from"]." на ".$_REQUEST["to"]."");
	foreach ($replace_ts as $k => $v)
	{
			$keys=array($v['field_name']=>$from[$v['field_name']]);
			$vals=array($v['field_name']=>$to[$v['field_name']]);
			//echo "*************************<br><pre>";
			//echo $v['table_name']."<br>";
			//print_r($keys);
			//print_r($vals);
			//echo "</pre>*************************<br>";
			$sql='update '.$v['table_name'].' set '.$v['field_name'].'='.$to[$v['field_name']].' where '.$v['field_name'].'='.$from[$v['field_name']];
			$dpt_needed = $db->getOne("SELECT COUNT (*) FROM user_tab_columns WHERE LOWER (table_name) = '".$v['table_name']."' AND LOWER (column_name) = 'dpt_id'");
			if ($dpt_needed==1) {$sql.=" and dpt_id=".$_SESSION["dpt_id"];}
			$db->query($sql);
			//echo $sql."<br>";
			audit("заменил ТС ".$_REQUEST["from"]." на ".$_REQUEST["to"]." ".$sql);
			//Table_Update($v['table_name'],$keys,$vals);
	}
	*/
}

$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=rtrim(file_get_contents('sql/replace_ts_list.sql'));
$sql=stritr($sql,$p);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);

$smarty->display('replace_ts.html');

?>