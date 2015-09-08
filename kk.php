<?
$smarty->display('kk_start.html');
//ses_req();


//$d=date("dmy");
$m=date("n");
$y=date("Y");

$smarty->assign('m', $m);
$smarty->assign('y', $y);

//echo $m." ".$y."<br>";


if ($_SESSION["_authsession"]["data"]["is_rmkk"]==1){$neednmkk=0;}
if ($_SESSION["_authsession"]["data"]["is_nmkk"]==1){$neednmkk=1;}






if ($_SESSION["_authsession"]["data"]["is_nmkk"]==1)
{
$neednmkk=1;
}
else
{
$neednmkk=0;
}



//if (($_SESSION["_authsession"]["data"]["is_rmkk"]==1)||($_SESSION["_authsession"]["data"]["is_nmkk"]==1))
//{
$sql=rtrim(file_get_contents('sql/oper_accept.sql'));
$params=array(
	':y'=>$y,
	':nets'=>0,
	':neednmkk'=>$neednmkk,
	':calendar_months'=>$m,
	':dpt_id'=>$_SESSION["dpt_id"],
	':tn_rmkk'=>0,
	':tn_mkk'=>0,
	':tn'=>$tn,
	':ok_filter'=>0
);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('fin_report', $data);
//echo $sql;
$smarty->display('kk_oper_accept.html');
//}




?><table><tr><td><?
include "html/instruction.html";
?></td></tr></table><?
$smarty->display('kk_end.html');
?>