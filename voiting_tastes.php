<?
	$sql = rtrim(file_get_contents('sql/voiting_tastes.sql'));
	$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('voiting_tastes', $d);
	$smarty->display('voiting_tastes.html');
?>




