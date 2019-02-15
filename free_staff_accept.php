<?
if (isset($_REQUEST["free"])&&isset($_REQUEST["free_staff"]))
{
	$pers1=$parameters["pers1"]["val_string"];
	$pers2=$parameters["pers2"]["val_string"];
	$accept1=$parameters["accept1"]["val_string"];
	$accept2=$parameters["accept2"]["val_string"];
	$it1=$parameters["it1"]["val_string"];
	$it2=$parameters["it2"]["val_string"];

	foreach ($_REQUEST["free_staff"] as $k=>$v)
	{
		$datauvol=$v["datauvol"];
		$block_email=$v["block_email"];
		$block_mob=$v["block_mob"];
		$block_portal=$v["block_portal"];

		$v["datauvol"]=OraDate2MDBDate($v["datauvol"]);
		$v["block_email"]=OraDate2MDBDate($v["block_email"]);
		$v["block_mob"]=OraDate2MDBDate($v["block_mob"]);
		$v["block_portal"]=OraDate2MDBDate($v["block_portal"]);
		Table_Update("free_staff",array("id"=>$k),$v);

		$email_creator=$db->getOne("select e_mail from user_list where tn=(select creator from free_staff where id=".$k.")");
		$fio_creator=$db->getOne("select fio from user_list where tn=(select creator from free_staff where id=".$k.")");
		$fio_staff=$db->getOne("select fio from user_list where tn=(select tn from free_staff where id=".$k.")");
		$dpt_staff=$db->getOne("select dpt_name from user_list where tn=(select tn from free_staff where id=".$k.")");
		$email_staff=$db->getOne("select e_mail from user_list where tn=(select tn from free_staff where id=".$k.")");
		$free_tn=$db->getOne("select tn from free_staff where id=".$k);
		$seat=$db->getOne("select name from free_staff_seat where id=(select seat from free_staff where id=".$k.")");

		isset($_REQUEST["r"]) ? $r=$_REQUEST["r"]: $r=array();
		isset($_REQUEST["comment"]) ? $comment=$_REQUEST["comment"]: $comment=array();
		if (isset($r[$k]))
		{
			$v["sz_id"]!=''?$sz="СЗ№: ".$v["sz_id"]."<br>":$sz="";
			if ($r[$k]==0)
			{
				$subj=$dpt_staff.". Запрос на увольнение сотрудника ".$fio_staff;
				$text="Здравствуйте.<br>";
				$text.="Заявка на увольнение сотрудника ".$fio_staff." отклонена.<br>";
				$text.="Это связано с неполнотой / некорректностью поданных Вами данных.<br>";
				$text.="Для осуществления технической процедуры увольнения Вам необходимо заново заполнить заявку с корректным указанием всей необходимой информации.<br>";
				$text.="Страна: ".$_SESSION["cnt_name"]."<br>";
				$text.=$sz;
				$comment[$k]!=''?$text.="Комментарий: <b>".$comment[$k]."</b><br>":null;
				send_mail($email_creator,$subj,$text,null);
				Table_Update("free_staff",array("id"=>$k),null);

			}
			if ($r[$k]==1)
			{
				$subj=$dpt_staff.". Увольнение сотрудника ".$fio_staff;
        
				$text="Здравствуйте.<br>";
				$text.="Здравствуйте, запрос на увольнение сотрудника ".$fio_staff." обработан и подтвержден.<br>Данный запрос отправлен ассистенту НДП, в отдел оплаты и ИТ-специалистам.<br>".$sz;
				$text.="Страна: ".$_SESSION["cnt_name"]."<br>";
				send_mail($email_creator,$subj,$text,null);
        
				$text="Здравствуйте.<br>";
				$text.="С ".$datauvol." увольняется сотрудник ".$fio_staff." руководителя ".$fio_creator.".<br>Причина увольнения - ".$seat.".<br>Условия увольнения: ".$v["params"].".<br>Просьба внести необходимые изменения в базу персонал<br>".$sz;
				$text.="Страна: ".$_SESSION["cnt_name"]."<br>";
				send_mail($pers1,$subj,$text,null);
				send_mail($pers2,$subj,$text,null);
        
				$text="Здравствуйте.<br>";
				$text.="С ".$datauvol." увольняется сотрудник ".$fio_staff." руководителя ".$fio_creator.".<br>Причина увольнения - ".$seat.".<br>Условия увольнения: ".$v["params"].".<br>Просьба учесть данную информацию при осуществлении выплат<br>".$sz;
				$text.="Страна: ".$_SESSION["cnt_name"]."<br>";
				send_mail($accept1,$subj,$text,null);
				send_mail($accept2,$subj,$text,null);
        
        
				$text="Здравствуйте.<br>";
				$text.="С ".$datauvol." увольняется сотрудник ".$fio_staff." руководителя ".$fio_creator.".<br>Причина увольнения - ".$seat.".<br>Условия увольнения: ".$v["params"].".<br>Просьба ограничить работу корпоративного мобильного номера и МТС-коннект с ".$block_mob."<br>".$sz;
				$text.="Страна: ".$_SESSION["cnt_name"]."<br>";
				send_mail($it1,$subj,$text,null);
        
				$text="Здравствуйте.<br>";
				$text.="С ".$datauvol." увольняется сотрудник ".$fio_staff." руководителя ".$fio_creator.".<br>Причина увольнения - ".$seat.".<br>Условия увольнения: ".$v["params"].".<br>Просьба заблокировать корпоративную электронную почту ".$email_staff." с ".$block_email."<br>".$sz;
				$text.="Страна: ".$_SESSION["cnt_name"]."<br>";
				send_mail($it2,$subj,$text,null);

				audit("доступ для ".$free_tn." отключен в связи с увольнением","free_staff_accept");

				Table_Update("free_staff",array("id"=>$k),array("accepted"=>1));
			}
		}
	}
}

$p = array(':dpt_id' => $_SESSION["dpt_id"]);

$sql=rtrim(file_get_contents('sql/free_staff.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($data as $k=>$v)
{
    $p = array(':tn' => $v["creator"]);
    $sql=rtrim(file_get_contents('sql/free_staff_childs.sql'));
    $sql=stritr($sql,$p);
    //echo $sql."<br>";
    $data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $data[$k]['childs']=$data1;

    $sql=rtrim(file_get_contents('sql/free_staff_my_emp_all.sql'));
    $p = array(':tn' => $v["creator"]);
    $sql=stritr($sql,$p);
    $data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $data[$k]['my_emp_all']=$data1;
}

$smarty->assign('free_staff', $data);


$sql=rtrim(file_get_contents('sql/free_staff_seat.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('seat', $data);

$smarty->display('free_staff_accept.html');

?>