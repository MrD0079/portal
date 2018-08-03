<?php

audit("открыл график обучения за ".$_REQUEST["month_list"],"fw");

InitRequestVar("fw_flt",1);
InitRequestVar("pos",0);



//$params=array(':pos_id'=>0,':dpt_id' => $_SESSION["dpt_id"],':files_activ'=>$_REQUEST["files_activ"]);
$p=array();

$p[':dpt_id'] = $_SESSION["dpt_id"];
$p[':sd'] = "'".$_REQUEST["month_list"]."'";
$p[':tn'] = $tn;
$p[':fw_flt'] = $_REQUEST["fw_flt"];
$p[':pos'] = $_REQUEST["pos"];

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql = rtrim(file_get_contents('sql/dates_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dates_list', $res);

$sql = rtrim(file_get_contents('sql/pos_list_actual.sql'));
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos_list', $res);

$sql = rtrim(file_get_contents('sql/fw.sql'));
$sql=stritr($sql,$p);
$fw = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('fw', $fw);

//echo $sql;

$smarty->display('fw.html');

?>