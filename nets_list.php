<?php
audit("����� � ������ �����");

if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_update("nets",array("id_net"=>$v),null);
	}
}

if (isset($_REQUEST["id_net"]))
{
	if($_REQUEST["id_net"]==0)
	{
		$new_id = get_new_id();
		Table_update("nets",array("id_net"=>$new_id),array("id_net"=>$new_id,'dpt_id' => $_SESSION["dpt_id"]));
		$_REQUEST["id_net"]=$new_id;
		$_POST["id_net"]=$new_id;
	}
}

if (isset($_REQUEST["activ_changed"]))
{
	foreach ($_REQUEST["activ_changed"] as $key => $val)
	{
		if ($val!=null)
		{
			audit("������� ������ ���� ".$key." �� ".Bool2Int($val));
			$table_name = 'nets';
			$fields_values = array('activ'=>Bool2Int($val));
			Table_Update($table_name, array('id_net'=>$key), $fields_values);
		}
	}
}

if (isset($_REQUEST["cat_a_changed"]))
{
	foreach ($_REQUEST["cat_a_changed"] as $key => $val)
	{
		if ($val!=null)
		{
			audit("������� ��������� ���� ".$key." �� ".Bool2Int($val));
			$table_name = 'nets';
			$fields_values = array('cat_a'=>Bool2Int($val));
			Table_Update($table_name, array('id_net'=>$key), $fields_values);
		}
	}
}

if (isset($_REQUEST["edit"]))
{
	audit("������� ��������� ���� ".$_REQUEST["edit_id_net"]);
	$table_name = 'nets';
	$fields_values = $_REQUEST["edit"];
	Table_Update($table_name, array('id_net'=>$key), $fields_values);
}



if (isset($_REQUEST["replace"]))
{
	audit("������� ������������� ����");
	if (($_REQUEST["rmkk_from"]!='')&&($_REQUEST["rmkk_to"]!=''))
	{
		Table_update("nets", array("tn_rmkk"=>$_REQUEST["rmkk_from"]), array("tn_rmkk"=>$_REQUEST["rmkk_to"]));
	}

	if (($_REQUEST["mkk_from"]!='')&&($_REQUEST["mkk_to"]!=''))
	{
		Table_update("nets", array("tn_mkk"=>$_REQUEST["mkk_from"]), array("tn_mkk"=>$_REQUEST["mkk_to"]));
		Table_update("promo_tm", array("tn"=>$_REQUEST["mkk_from"]), array("tn"=>$_REQUEST["mkk_to"]));
		Table_update("nets_plan_month", array("payment_type"=>1, "plan_type"=>3, "mkk_ter"=>$_REQUEST["mkk_from"]), array("mkk_ter"=>$_REQUEST["mkk_to"]));
		Table_update("nets_plan_month", array("payment_type"=>3, "plan_type"=>3, "mkk_ter"=>$_REQUEST["mkk_from"]), array("mkk_ter"=>$_REQUEST["mkk_to"]));
	}
}

$sql=rtrim(file_get_contents('sql/nets_list.sql'));
$params = array(':tn' => $tn,':dpt_id' => $_SESSION["dpt_id"],':activ'=>$_REQUEST['activ']);
$sql=stritr($sql,$params);
$nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $nets);

$sql=rtrim(file_get_contents('sql/list_rmkk.sql'));
$params = array(':tn' => $tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
//echo $sql;
$list_rmkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_rmkk', $list_rmkk);

$sql=rtrim(file_get_contents('sql/list_mkk.sql'));
$params = array(':tn' => $tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$list_mkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk', $list_mkk);

$sql=rtrim(file_get_contents('sql/nets_status.sql'));
$nets_status = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets_status', $nets_status);



$smarty->display('nets_list.html');

?>