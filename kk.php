<?
$smarty->display('kk_start.html');

$m=date("n");
$y=date("Y");

$smarty->assign('m', $m);
$smarty->assign('y', $y);

$sql=rtrim(file_get_contents('sql/oper_accept.sql'));
$params=array(
	':y'=>$y,
	':nets'=>0,
	':calendar_months'=>$m,
	':dpt_id'=>$_SESSION["dpt_id"],
	':tn_rmkk'=>0,
	':tn_mkk'=>0,
	':tn'=>$tn,
	':ok_filter'=>0,
	':mgroups'=>0,
);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('fin_report', $data);
$smarty->display('kk_oper_accept.html');

?><table><tr><td><?
include "html/instruction.html";
?></td></tr></table><?
$smarty->display('kk_end.html');
?>