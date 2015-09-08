<?php

//audit("вошел в список сетей");
//ses_req();






InitRequestVar("zhuv_chief_list",0);
InitRequestVar("zhuv_ts_list",0);

$params=array(
	':tn'=>$tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':zhuv_chief_list' => $_REQUEST["zhuv_chief_list"],
	':zhuv_ts_list' => $_REQUEST["zhuv_ts_list"]
);


$sql=rtrim(file_get_contents('sql/zhuv_process.sql'));
$sql=stritr($sql,$params);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);


//print_r($list);


$sql_total=rtrim(file_get_contents('sql/zhuv_process_total.sql'));
$sql_total=stritr($sql_total,$params);
$list_total = $db->getAll($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_total', $list_total);


$s2=rtrim(file_get_contents('sql/zhuv_process_total_total.sql'));
$s2=stritr($s2,$params);
//$t2 = $db->getOne($s2);
$t2 = $db->getRow($s2, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('t2', $t2);






foreach ($list_total as $k=>$v)
{
$d[$v["tab_num"]]["fio"]=$v["fio"];
$d[$v["tab_num"]]["parent_fio"]=$v["parent_fio"];
$d[$v["tab_num"]]["parent_tn"]=$v["parent_tn"];
$d[$v["tab_num"]]["c"]=$v["c"];
$d[$v["tab_num"]]["total"]=$v;
}


foreach ($list as $k=>$v)
{
$d[$v["tab_num"]]["data"][$v["fio_eta"]]=$v;
}


isset($d) ? $smarty->assign('d', $d) : null;




//isset($_REQUEST["debug"])?print_r($d):null;







$sql = rtrim(file_get_contents('sql/zhuv_ts_list.sql'));
$sql=stritr($sql,$params);
$zhuv_ts_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('zhuv_ts_list', $zhuv_ts_list);

$sql = rtrim(file_get_contents('sql/zhuv_chief_list.sql'));
$sql=stritr($sql,$params);
$zhuv_chief_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('zhuv_chief_list', $zhuv_chief_list);






$smarty->display('zhuv_process.html');

?>