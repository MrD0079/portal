<?php

$sql=rtrim(file_get_contents('sql/bud_replace_db_fil_list.sql'));
$params=array(':tn' => $_REQUEST['tn']);
$sql=stritr($sql,$params);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);

$smarty->display('bud_replace_db_fil_list.html');

?>