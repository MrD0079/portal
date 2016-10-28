<?php

InitRequestVar("tr",0);

ses_req();

if (isset($_REQUEST["test_on"])) {
    foreach ($_REQUEST["test_on"] as $key => $val) {
        $db->query("insert into voiting_test_onoff (tn,tr) values (".$val.",".$_REQUEST["tr"].")");
		audit("включил прохождение теста ".$_REQUEST["tr"]." для ".$val);
    }
}

if (isset($_REQUEST["test_all_on"])) {
	$db->query("DELETE FROM voiting_test_onoff WHERE tr = ".$_REQUEST["tr"]);
	$db->query("INSERT INTO voiting_test_onoff (tn, tr) SELECT u.tn, ".$_REQUEST["tr"]." FROM user_list u WHERE u.is_prez = 1");
	audit("включил прохождение теста ".$_REQUEST["tr"]." для всех");
}
if (isset($_REQUEST["test_all_off"])) {
	$db->query("DELETE FROM voiting_test_onoff WHERE tr = ".$_REQUEST["tr"]);
	audit("выключил прохождение теста ".$_REQUEST["tr"]." для всех");
}

$data = $db->getAll("
SELECT u.tn, u.fio, t.tr
FROM voiting_test_onoff t, user_list u
WHERE u.is_prez = 1 AND u.tn = t.tn(+) AND ".$_REQUEST["tr"]." = t.tr(+)
order by u.fio
", null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('test_list', $data);

$data = $db->getAll("SELECT * FROM tr where for_prez = 1 ORDER BY name", null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr', $data);

$smarty->display('voiting_test_onoff.html');

?>