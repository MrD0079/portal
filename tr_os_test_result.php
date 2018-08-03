<?

audit ("открыл форму Обратная связь и результаты теста","tr");



$p = array();
$p[':id'] = $_REQUEST["id"];

$sql=rtrim(file_get_contents('sql/tr_list_order.sql'));
$sql=stritr($sql,$p);
$h = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('h', $h);

$sql=rtrim(file_get_contents('sql/tr_os_test_result.sql'));
$sql=stritr($sql,$p);
$tru = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($tru as $k => $v)
{
	$p[':tn'] = $v['tn'];

	$d[$v['id']]['head']=$v;

	$sql=rtrim(file_get_contents('sql/tr_os_test_result_tests.sql'));
	$sql=stritr($sql,$p);
	$tests = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

	foreach ($tests as $k1 => $v1)
	{
		isset($v1['test_id']) ? $d[$v['id']]['tests'][$v1['test_id']]=$v1 : null;
	}

	$sql=rtrim(file_get_contents('sql/tr_os_test_result_test_res.sql'));
	$sql=stritr($sql,$p);
	$test_res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($test_res as $k2 => $v2)
	{
		isset($v2['q_id']) ? $d[$v['id']]['test_res'][$v2['q_id']]=$v2 : null;
	}
}

isset($d)?$smarty->assign('tru', $d):null;

$smarty->display('tr_os_test_result.html');

?>