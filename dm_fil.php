<?php

//ses_req();
audit("����� � �������� �������-������������","dm_fil");

if (isset($_REQUEST["new"])) {
Table_Update("dm_fil",$_REQUEST["add"],$_REQUEST["add"]);
    audit("������� ������ � ������","dm_fil");
}


if (isset($_REQUEST["del"])) {
   foreach ($_REQUEST["del"] as $key => $val)
   {
    $a = split(",", $val);
    $params = array(
     'tn' => $a[0],
     'bud_id' => $a[1]
    );
    Table_Update("dm_fil",$params,null);
    audit("������ ������ �� ������","dm_fil");
   }
}

$p = array(
	":dpt_id" => $_SESSION["dpt_id"],
);

$sql = rtrim(file_get_contents('sql/dm_fil.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $data);

$sql = rtrim(file_get_contents('sql/dm_list_fil.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_fil', $data);

$sql = rtrim(file_get_contents('sql/dm_list.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_tn', $data);




$smarty->display('dm_fil.html');



?>