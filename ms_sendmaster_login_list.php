<?php

$sql=rtrim(file_get_contents('sql/ms_sendmaster_logins_list.sql'));
$params=array(':ag' => $_REQUEST['ag']);
$sql=stritr($sql,$params);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);

$smarty->display('ms_sendmaster_login_list.html');

?>