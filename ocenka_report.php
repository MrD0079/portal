<?

audit("просмотрел полный отчет","ocenka");

include "ocenka_events.php";

InitRequestVar("parent",0);
InitRequestVar("spd",0);
InitRequestVar("pos",0);

$p = array(
      ':dpt_id' => $_SESSION["dpt_id"],
      ':event' => $_REQUEST["event"],
      ':parent' => $_REQUEST["parent"],
      ':spd' => $_REQUEST["spd"],
      ':pos' => $_REQUEST["pos"],
      ':tn' => $tn
    );


$sql = rtrim(file_get_contents('sql/ocenka_report.sql'));
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('report', $res);

$sql = rtrim(file_get_contents('sql/ocenka_report_total.sql'));
$sql=stritr($sql,$p);
$report_total = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('report_total', $report_total);

$sql = rtrim(file_get_contents('sql/ocenka_report_parents.sql'));
$sql=stritr($sql,$p);
$r1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('parents', $r1);

$sql = rtrim(file_get_contents('sql/pos_list_actual.sql'));
$sql=stritr($sql,$p);
$r2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos', $r2);

$sql = rtrim(file_get_contents('sql/spd_list.sql'));
$sql=stritr($sql,$p);
$r2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list', $r2);



//print_r($p);


if (isset($_REQUEST["generate"]))
{

$test_errors = array();
$exp_comm = array();

foreach ($res as $val)
{
//print_r($val);
//echo $val["emp_tn"]."<br>";
$sql = rtrim(file_get_contents('sql/ocenka_get_test_errors.sql'));
$p = array(
      ':tn' => $val["emp_tn"],
      ':event' => $_REQUEST["event"]
    );
$sql=stritr($sql,$p);
$res1 = $db->getassoc($sql);
//$res1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//echo $sql;
//print_r($res1);
//exit;
$test_errors[$val["rownum"]] = $res1;
//print_r($res1);

$sql = rtrim(file_get_contents('sql/ocenka_get_exp_comm.sql'));
$p = array(
      ':tn' => $val["emp_tn"],
      ':event' => $_REQUEST["event"]
    );
$sql=stritr($sql,$p);
$exp_comm_item = $db->getassoc($sql);
//$exp_comm_item = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$exp_comm[$val["rownum"]] = $exp_comm_item;

}
$smarty->assign('test_errors', $test_errors);
$smarty->assign('exp_comm', $exp_comm);
//print_r($test_errors);

}

$smarty->display('ocenka_report.html');
?>