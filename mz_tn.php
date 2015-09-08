<?php

//ses_req();
audit("вошел в привязку музеи-люди","mz");


if (isset($_REQUEST["new"])) {
Table_Update("mz_tn",$_REQUEST["add"],$_REQUEST["add"]);
    audit("добавил запись в список","mz");
}


if (isset($_REQUEST["del"])) {
   foreach ($_REQUEST["del"] as $key => $val)
   {
    $a = split(",", $val);
    $params = array(
     'tn' => $a[0],
     'mz_id' => $a[1]
    );
    Table_Update("mz_tn",$params,null);
    audit("удалил запись из списка","mz");
   }
}



$sql = rtrim(file_get_contents('sql/mz_tn.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('emp_exp', $data);

$sql = rtrim(file_get_contents('sql/mz_tn_list.sql'));
//$p = array(':dpt_id' => $_SESSION["dpt_id"]);
//$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('mz_tn_list', $data);

$sql = rtrim(file_get_contents('sql/mz_spr_mz.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('mz_list', $data);




$smarty->display('mz_tn.html');



?>