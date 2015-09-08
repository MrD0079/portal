<?

if (isset($_REQUEST["free_staff"]))
{
	$du=$_REQUEST["free_staff"]["datauvol"];
	$_REQUEST["free_staff"]["datauvol"]=OraDate2MDBDate($_REQUEST["free_staff"]["datauvol"]);
	$_REQUEST["free_staff"]["block_email"]=OraDate2MDBDate($_REQUEST["free_staff"]["block_email"]);
	$_REQUEST["free_staff"]["block_mob"]=OraDate2MDBDate($_REQUEST["free_staff"]["block_mob"]);
	$_REQUEST["free_staff"]["block_portal"]=OraDate2MDBDate($_REQUEST["free_staff"]["block_portal"]);
	$_REQUEST["free_staff"]["creator"]=$tn;
	Table_Update("free_staff",$_REQUEST["free_staff"],$_REQUEST["free_staff"]);

	$res=$db->getAll("select e_mail from user_list where is_admin=1 and e_mail is not null AND tn <> 2885600038", null, null, null, MDB2_FETCHMODE_ASSOC);
	$creator_fio=$db->getOne("select fio from user_list where tn=".$_REQUEST["free_staff"]["creator"]);
	$free_fio=$db->getOne("select fio from user_list where tn=".$_REQUEST["free_staff"]["tn"]);
	foreach($res as $k=>$v)
	{
		$subj="Поступила заявка на увольнение сотрудника";
		$text="Здравствуйте.<br>";
		$text.="Поступила заявка на увольнение сотрудника<br>";
		$text.="Ф.И.О. увольняемого: ".$free_fio."<br>";
		$text.="Ф.И.О. подавшего заявку: ".$creator_fio."<br>";
		$text.="Дата увольнения: ".$du."<br>";
		$text.="Страна: ".$_SESSION["cnt_name"]."<br>";
		$_REQUEST["free_staff"]["sz_id"]!=''?$text.="СЗ№: ".$_REQUEST["free_staff"]["sz_id"]."<br>":null;
		send_mail($v["e_mail"],$subj,$text,null);
	}



}

$sql=rtrim(file_get_contents('sql/free_staff_my_emp.sql'));
$params=array(':tn'=>$tn);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('my_emp', $data);

$sql=rtrim(file_get_contents('sql/free_staff_my_emp_all.sql'));
$params=array(':tn'=>$tn);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('my_emp_all', $data);

$sql=rtrim(file_get_contents('sql/free_staff_seat.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('seat', $data);



$p = array(':tn' => $tn);
$sql=rtrim(file_get_contents('sql/free_staff_childs.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('childs', $data);



$smarty->display('free_staff.html');

?>