<?
	InitRequestVar("tr",0);

	$data = $db->getAll("SELECT * FROM tr where for_prez = 1 ORDER BY name", null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('tr', $data);

        
        $sql="
  SELECT u.fio,
         b.test_ball,
         b.sec,
            TRUNC (b.sec / 60)
         || DECODE (TRUNC (b.sec / 60), NULL, NULL, ':')
         || TRUNC ( (b.sec - TRUNC (b.sec / 60) * 60))
         || ''
            time
    FROM tr,
         (SELECT b.head,
                 b.tn,
                 b.test_ball,
                 (b.test_finished - b.test_started) * 24 * 60 * 60 sec
            FROM VOITING_ORDER_BODY b) b,
         user_list u
   WHERE     tr.id = ".$_REQUEST["tr"]."
         AND tr.for_prez = 1
         AND tr.id = b.head
         AND b.tn = u.tn
ORDER BY b.test_ball, b.sec DESC, u.fio";
        //$_REQUEST["sql"]=$sql;
        
        /*
        $sql="SELECT u.fio, b.test_ball
    FROM tr, VOITING_ORDER_BODY b, user_list u
   WHERE tr.id = ".$_REQUEST["tr"]." AND tr.for_prez = 1 AND tr.id = b.head AND b.tn = u.tn
ORDER BY b.test_ball, u.fio";*/
        //echo $sql;
        
	$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('data', $d);
	$smarty->display('voiting_summary_by_users.html');
?>




