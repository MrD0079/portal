<?php

//audit("вошел в список сетей");
//ses_req();






InitRequestVar("thing_chief_list",0);
InitRequestVar("thing_ts_list",0);

$params=array(
	':tn'=>$tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':thing_chief_list' => $_REQUEST["thing_chief_list"],
	':thing_ts_list' => $_REQUEST["thing_ts_list"]
);


$sql=rtrim(file_get_contents('sql/thing_july_process.sql'));
$sql=stritr($sql,$params);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);

$sql_total=rtrim(file_get_contents('sql/thing_july_process_total.sql'));
$sql_total=stritr($sql_total,$params);
$list_total = $db->getAll($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_total', $list_total);


$s2=rtrim(file_get_contents('sql/thing_july_process_total_total.sql'));
$s2=stritr($s2,$params);
$t2 = $db->getRow($s2, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('t2', $t2);






foreach ($list_total as $k=>$v)
{
$d[$v["tab_num"]]["fio"]=$v["fio"];
$d[$v["tab_num"]]["parent_fio"]=$v["parent_fio"];
$d[$v["tab_num"]]["c"]=$v["c"];
$d[$v["tab_num"]]["bt"]=$v["bt"];
}


foreach ($list as $k=>$v)
{
$d[$v["tab_num"]]["data"][$v["fio_eta"]]=$v;
}


isset($d) ? $smarty->assign('d', $d) : null;



$sql_total=rtrim(file_get_contents('sql/thing_july_process_total_parents.sql'));
$sql_total=stritr($sql_total,$params);
$list_total_parents = $db->getAll($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_total_parents', $list_total_parents);









$sql = rtrim(file_get_contents('sql/thing_ts_list.sql'));
$sql=stritr($sql,$params);
$thing_ts_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('thing_ts_list', $thing_ts_list);

$sql = rtrim(file_get_contents('sql/thing_chief_list.sql'));
$sql=stritr($sql,$params);
$thing_chief_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('thing_chief_list', $thing_chief_list);






$smarty->display('thing_july_process.html');

?>