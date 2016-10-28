<?
	$sql = rtrim(file_get_contents('sql/voiting_avg_balls.sql'));
	$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('balls', $d);
	$smarty->display('voiting_avg_balls.html');
?>




