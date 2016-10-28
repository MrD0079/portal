<?php



//ses_req();

audit("вошел в замену исполнителей/согласователей","sz_change");

if (isset($_REQUEST["replace_executors"]))
{
	$f=$db->getOne("select fio from user_list where tn=".$_REQUEST["executors_from"]);
	$t=$db->getOne("select fio from user_list where tn=".$_REQUEST["executors_to"]);
	audit("заменил исполнителя: ".$f." => ".$t."","sz_change");
	Table_Update("sz_executors",array("tn"=>$_REQUEST["executors_from"]),array("tn"=>$_REQUEST["executors_to"]));
}

if (isset($_REQUEST["replace_acceptors"]))
{
	//Table_Update("sz_executors",array("tn"=>$_REQUEST["acceptors_from"]),array("tn"=>$_REQUEST["acceptors_to"]));

	$f=$db->getOne("select fio from user_list where tn=".$_REQUEST["acceptors_from"]);
	$t=$db->getOne("select fio from user_list where tn=".$_REQUEST["acceptors_to"]);
	//audit("заменил согласователя: ".$f." => ".$t." за период с ".$_REQUEST['dt_from']." по ".$_REQUEST['dt_to'],"sz_change");
	audit("заменил согласователя: ".$f." => ".$t,"sz_change");

	//isset($_REQUEST['dt_from'])?$_REQUEST['dt_from']=OraDate2MDBDate($_REQUEST['dt_from']):null;
	//isset($_REQUEST['dt_to'])?$_REQUEST['dt_to']=OraDate2MDBDate($_REQUEST['dt_to']):null;
	//$sql="BEGIN SZREPLACCEPT (".$_REQUEST["acceptors_from"].", ".$_REQUEST["acceptors_to"].",TO_DATE ('".$_REQUEST['dt_from']."', 'dd.mm.yyyy'),TO_DATE ('".$_REQUEST['dt_to']."', 'dd.mm.yyyy')); END;";
	$sql="BEGIN SZREPLACCEPT (".$_REQUEST["acceptors_from"].", ".$_REQUEST["acceptors_to"]."); END;";
	//echo $sql;
	$db->query($sql);
	//ses_req();
}

$sql = rtrim(file_get_contents('sql/sz_change_executors_from.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('executors_from', $data);

$sql = rtrim(file_get_contents('sql/sz_change_executors_to.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('executors_to', $data);

$sql = rtrim(file_get_contents('sql/sz_change_acceptors_from.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('acceptors_from', $data);

$sql = rtrim(file_get_contents('sql/sz_change_acceptors_to.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('acceptors_to', $data);


$sql = rtrim(file_get_contents('sql/sz_change_acceptors_to.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('acceptors_to', $data);





$smarty->display('sz_change.html');

?>