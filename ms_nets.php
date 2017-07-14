<?php


audit("вошел в список сетей MS");

//ses_req();


if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_update("ms_nets",array("id_net"=>$v),null);
	}
}




if (isset($_REQUEST["id_net"]))
{
	if($_REQUEST["id_net"]==0)
	{
		$new_id = &$db->getOne("SELECT NVL (MAX (ID_NET), 0) + 1 FROM ms_nets");
		Table_update("ms_nets",array("id_net"=>$new_id),array("id_net"=>$new_id));
		$_REQUEST["id_net"]=$new_id;
		$_POST["id_net"]=$new_id;
	}
}






if (isset($_REQUEST["edit"]))
{
	audit("изменил параметры сети ".$_REQUEST["edit_id_net"]);
	$table_name = 'ms_nets';
	$fields_values = $_REQUEST["edit"];
	$affectedRows = $db->extended->autoExecute($table_name, $fields_values, MDB2_AUTOQUERY_UPDATE, 'id_net='.$_REQUEST["edit_id_net"]);
	if (PEAR::isError($affectedRows)) { echo $affectedRows->getMessage(); }
}




$sql=rtrim(file_get_contents('sql/list_mkk.sql'));
$params = array(':tn' => $tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$list_mkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_tmkk', $list_mkk);


$sql=rtrim(file_get_contents('sql/ms_nets.sql'));
$params=array(':tn'=>$tn);
$sql=stritr($sql,$params);
$ms_nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ms_nets', $ms_nets);



$smarty->display('ms_nets.html');

?>