<?php

$sql = rtrim(file_get_contents('sql/w4u_admin_vp_load_prod_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pl', $res);
$smarty->display('w4u_admin_vp_load_prod_list.html');

?>