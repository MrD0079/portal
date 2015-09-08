<?

audit("ןנמסלמענוכ מעקוע ןמ ".$_REQUEST["emp_tn"]);


include "ocenka_events.php";


$params4fio = array($_REQUEST["emp_tn"]);
$res_fio = &$db->getone("SELECT fn_getname(?) from dual", null,$params4fio);
$smarty->assign('emp_fio', $res_fio);




$sql = rtrim(file_get_contents('sql/ocenka_report_self.sql'));
$p = array(
      ':tn' => $_REQUEST["emp_tn"],
      ':event' => $_REQUEST["event"]
    );
$sql=stritr($sql,$p);
//echo $sql;
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($res);
$smarty->assign('report_self', $res);

$sql = rtrim(file_get_contents('sql/ocenka_get_test_result.sql'));
$p = array(
      ':tn' => $_REQUEST["emp_tn"],
      ':event' => $_REQUEST["event"]
    );
$sql=stritr($sql,$p);
$test_result = $db->getOne($sql);
$smarty->assign('test_result', $test_result);


$sql = rtrim(file_get_contents('sql/ocenka_get_test_errors.sql'));
$p = array(
      ':tn' => $_REQUEST["emp_tn"],
      ':event' => $_REQUEST["event"]
    );
$sql=stritr($sql,$p);
$test_errors = &$db->getAssoc($sql);
$smarty->assign('test_errors', $test_errors);


$sql = rtrim(file_get_contents('sql/ocenka_get_exp_comm.sql'));
$p = array(
      ':tn' => $_REQUEST["emp_tn"],
      ':event' => $_REQUEST["event"]
    );
$sql=stritr($sql,$p);
$exp_comm = &$db->getAssoc($sql);
$smarty->assign('exp_comm', $exp_comm);



$smarty->display('ocenka_report_self.html');






?>