<?php

//audit("вошел в список сетей");
//ses_req();



InitRequestVar("type",2); // по умолчанию считаем балл по С-В



InitRequestVar("apvd_chief_list",0);
InitRequestVar("apvd_ts_list",0);

$params=array(
	':tn'=>$tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':apvd_chief_list' => $_REQUEST["apvd_chief_list"],
	':apvd_ts_list' => $_REQUEST["apvd_ts_list"]
);


$sql=rtrim(file_get_contents('sql/apvd_process.sql'));
$sql=stritr($sql,$params);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);



//print_r($list);


$sql_total=rtrim(file_get_contents('sql/apvd_process_total.sql'));
$sql_total=stritr($sql_total,$params);
$list_total = $db->getAll($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_total', $list_total);


//echo $sql_total;




$s2=rtrim(file_get_contents('sql/apvd_process_total_total.sql'));
$s2=stritr($s2,$params);
$t2 = $db->getRow($s2, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('t2', $t2);






foreach ($list_total as $k=>$v)
{

$d[$v["tab_num"]]["head"]=$v;
/*
$d[$v["tab_num"]]["fio_ts"]=$v["fio_ts"];
$d[$v["tab_num"]]["fio_parent"]=$v["fio_parent"];
$d[$v["tab_num"]]["c"]=$v["c"];
$d[$v["tab_num"]]["ob"]=$v["ob"];
$d[$v["tab_num"]]["obsv"]=$v["obsv"];
*/
}


foreach ($list as $k=>$v)
{
$d[$v["tab_num"]]["data"][$v["fio_eta"]]=$v;
}





isset($d) ? $smarty->assign('d', $d) : null;












$sql = rtrim(file_get_contents('sql/apvd_ts_list.sql'));
$sql=stritr($sql,$params);
$apvd_ts_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('apvd_ts_list', $apvd_ts_list);

$sql = rtrim(file_get_contents('sql/apvd_chief_list.sql'));
$sql=stritr($sql,$params);
$apvd_chief_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('apvd_chief_list', $apvd_chief_list);






$smarty->display('apvd_process.html');

?>