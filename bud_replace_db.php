<?php

audit("вошел в замену ДБ");


$sql=rtrim(file_get_contents('sql/bud_replace_db.sql'));
$bud_replace_db = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_replace_db', $bud_replace_db);

if (isset($_REQUEST["replace"])&&($_REQUEST["from"]!='')&&($_REQUEST["to"]!=''))
{
$sql='begin pr_bud_replace_db ('.$_REQUEST["from"].','.$_REQUEST["to"].','.$_REQUEST["fil"].','.$tn.'); end;';
//echo $sql;
$db->query($sql);
}

if (isset($_REQUEST["replace_accept"])&&($_REQUEST["from_accept"]!='')&&($_REQUEST["to_accept"]!=''))
{
$sql='begin pr_bud_replace_db_accept ('.$_REQUEST["from_accept"].','.$_REQUEST["to_accept"].','.$tn.'); end;';
//echo $sql;
$db->query($sql);
}


$sql=rtrim(file_get_contents('sql/bud_replace_db_list.sql'));
$params=array(':actual' => 0);
$sql=stritr($sql,$params);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);

$sql=rtrim(file_get_contents('sql/bud_replace_db_list.sql'));
$params=array(':actual' => 1);
$sql=stritr($sql,$params);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_actual', $list);

$params=array(':dpt_id' => $_SESSION["dpt_id"],':actual' => 0);
$sql=rtrim(file_get_contents('sql/emp_exp_spd_list_by_dpt_id.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('emp', $d);

$params=array(':dpt_id' => $_SESSION["dpt_id"],':actual' => 1);
$sql=rtrim(file_get_contents('sql/emp_exp_spd_list_by_dpt_id.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('emp_actual', $d);




$smarty->display('bud_replace_db.html');

?>