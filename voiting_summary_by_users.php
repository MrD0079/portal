<?
	InitRequestVar("tr",0);

	$data = $db->getAll("SELECT * FROM tr where for_prez = 1 ORDER BY name", null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('tr', $data);

	$d = $db->getAll("SELECT u.fio, b.test_ball
    FROM tr, VOITING_ORDER_BODY b, user_list u
   WHERE tr.id = ".$_REQUEST["tr"]." AND tr.for_prez = 1 AND tr.id = b.head AND b.tn = u.tn
ORDER BY b.test_ball, u.fio", null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('data', $d);
	$smarty->display('voiting_summary_by_users.html');
?>




