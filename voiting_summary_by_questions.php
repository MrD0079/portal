<?
	InitRequestVar("tr",0);

	$data = $db->getAll("SELECT * FROM tr where for_prez = 1 ORDER BY name", null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('tr', $data);

	$d = $db->getAll("SELECT SUM (b.ok) ok, qa.name
    FROM tr,
         VOITING_ORDER_TEST_RES b,
         user_list u,
         tr_test_qa qa
   WHERE     tr.id = ".$_REQUEST["tr"]."
         AND tr.for_prez = 1
         AND tr.id = b.head
         AND b.tn = u.tn
         AND qa.TYPE = 5
         AND qa.tr = tr.id
         AND b.q = qa.id_num
GROUP BY qa.name, b.q
ORDER BY ok, qa.name", null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('data', $d);
	$smarty->display('voiting_summary_by_questions.html');
?>




