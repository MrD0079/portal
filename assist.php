<?php


audit("вошел в список ассистентов");


if (isset($_REQUEST["new"])) {
Table_Update("assist",$_REQUEST["add"],$_REQUEST["add"]);
    audit("добавил запись в список ассистентов");
}


if (isset($_REQUEST["accept"])) {
   foreach ($_REQUEST["accept"] as $key => $val)
   {
    $a = explode(",", $key);
    $params = array(
     'child' => $a[0],
     'parent' => $a[1],
     'dpt_id' => $a[2]
    );
    Table_Update("assist",$params,array("accept"=>$val));
    audit("сохранил запись в списке ассистентов");
   }
}



if (isset($_REQUEST["del"])) {
   foreach ($_REQUEST["del"] as $key => $val)
   {
    $a = explode(",", $val);
    $params = array(
     'child' => $a[0],
     'parent' => $a[1],
     'dpt_id' => $a[2]
    );
    Table_Update("assist",$params,null);
    audit("удалил запись из списка ассистентов");
   }
}







$sql = rtrim(file_get_contents('sql/assist.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('emp_exp', $data);

$sql = rtrim(file_get_contents('sql/emp_exp_spd_list.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list', $data);





$smarty->display('assist.html');



?>