<?php

audit("вошел в привязку рынки-люди","dpnr");

if (isset($_REQUEST["new"])) {
Table_Update("dpnr_market_tn",$_REQUEST["add"],$_REQUEST["add"]);
    audit("добавил запись в список","mz");
}

if (isset($_REQUEST["del"])) {
   foreach ($_REQUEST["del"] as $key => $val)
   {
    $a = split(",", $val);
    $params = array(
     'tn' => $a[0],
     'm_id' => $a[1]
    );
    Table_Update("dpnr_market_tn",$params,null);
    audit("удалил запись из списка","mz");
   }
}

$p = array(":tn" => $tn,':dpt_id'=>$_SESSION['dpt_id']);

$sql = rtrim(file_get_contents('sql/dpnr_market_tn.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('emp_exp', $data);

$sql = rtrim(file_get_contents('sql/spd_list.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('m_tn_list', $data);

$sql = rtrim(file_get_contents('sql/dpnr_markets.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('m_list', $data);

$smarty->display('dpnr_market_tn.html');

?>