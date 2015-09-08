<?

audit("открыл ac_test_report","ac_test_report");

$sql=rtrim(file_get_contents('sql/ac_report_list_years.sql'));
$p = array(
':dpt_id' => $_SESSION["dpt_id"]
);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);


if (isset($_REQUEST["ac_id"]))
{

$_REQUEST["y"]=$db->getOne("select to_char(dt,'yyyy') from ac where id=".$_REQUEST["ac_id"]);

}


$smarty->display('ac_test_report.html');

?>