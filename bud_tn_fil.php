<?php


audit("вошел в привязку филиалы-люди","bud");


InitRequestVar('fil_activ',1);
InitRequestVar('kk',2);

if (isset($_REQUEST["new"])) {
Table_Update("bud_tn_fil",$_REQUEST["add"],$_REQUEST["add"]);
    audit("добавил запись в список","bud");
}


if (isset($_REQUEST["del"])) {
   foreach ($_REQUEST["del"] as $key => $val)
   {
    $a = explode(",", $val);
    $params = array(
     'tn' => $a[0],
     'bud_id' => $a[1]
    );
    Table_Update("bud_tn_fil",$params,null);
    audit("удалил запись из списка","bud");
   }
}

$p = array(
	":dpt_id" => $_SESSION["dpt_id"],
	':fil_activ'=>$_REQUEST["fil_activ"],
	':kk'=>$_REQUEST["kk"]
);

$sql = rtrim(file_get_contents('sql/bud_tn_fil.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('emp_exp', $data);

$sql = rtrim(file_get_contents('sql/bud_fil.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_fil', $data);

$sql = rtrim(file_get_contents('sql/bud_tn_list_tn.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_tn', $data);




$smarty->display('bud_tn_fil.html');



?>