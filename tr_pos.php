<?php


audit("вошел в привязку музеи-люди","tr");


if (isset($_REQUEST["new"])) {
Table_Update("tr_pos",$_REQUEST["add"],$_REQUEST["add"]);
    audit("добавил запись в список","tr");
}


if (isset($_REQUEST["del"])) {
   foreach ($_REQUEST["del"] as $key => $val)
   {
    $a = explode(",", $val);
    $params = array(
     'pos_id' => $a[0],
     'tr_id' => $a[1]
    );
    Table_Update("tr_pos",$params,null);
    audit("удалил запись из списка","tr");
   }
}

$p = array(':dpt_id' => $_SESSION["dpt_id"]);


$sql = rtrim(file_get_contents('sql/tr_pos.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr_pos', $data);

$sql = rtrim(file_get_contents('sql/tr_pos_list.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr_pos_list', $data);

$sql = rtrim(file_get_contents('sql/tr.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr', $data);

$smarty->display('tr_pos.html');



?>