<?

if (isset($_REQUEST["save"])&&isset($_REQUEST["new_staff"]))
{
	foreach ($_REQUEST["new_staff"] as $k=>$v)
	{
		$v["datastart"]=OraDate2MDBDate($v["datastart"]);
		$v["limitkom"]=str_replace(",", ".", $v["limitkom"]);
		$v["limittrans"]=str_replace(",", ".", $v["limittrans"]);
		$v["limit_car_vol"]=str_replace(",", ".", $v["limit_car_vol"]);
		Table_Update("new_staff",array("id"=>$k),$v);
	}
	if (isset($_REQUEST["new_staff_detail"]))
	{
		foreach ($_REQUEST["new_staff_detail"] as $k=>$v)
		{
			if (isset($v["childs"]))
			{
				foreach ($v["childs"] as $k1=>$v1)
				{
					($v1=='')?Table_Update("new_staff_childs",array("id"=>$k1),null):null;
				}
			}
			if (isset($v["bud_fil"]))
			{
				foreach ($v["bud_fil"] as $k1=>$v1)
				{
					//Table_Update("new_staff_bud_fil",array("id"=>$k1),$v):null;
					$keys = array('parent'=>$k,'fil'=>$k1);
					$vals = array('fil'=>$k1);
					($v1=='')?$vals=null:null;
					Table_Update("new_staff_bud_fil",$keys,$vals);
				}
			}
		}
	}
	if (isset($_REQUEST["r"]))
	{
		$pers1=$parameters["pers1"]["val_string"];
		$pers2=$parameters["pers2"]["val_string"];
		$accept1=$parameters["accept1"]["val_string"];
		$accept2=$parameters["accept2"]["val_string"];
		isset($_REQUEST["comment"]) ? $comment=$_REQUEST["comment"]: $comment=array();

		foreach ($_REQUEST["r"] as $k=>$v)
		{
			$email_creator=$db->getOne("select e_mail from user_list where tn=(select creator from new_staff where id=".$k.")");
			$fio_creator=$db->getOne("select fio from user_list where tn=(select creator from new_staff where id=".$k.")");
			$fio_staff=$db->getOne("select fam||' '||im||' '||otch from new_staff where id=".$k);
			$file_name=$db->getOne("select fn from new_staff where id=".$k);
			$file_name1=$db->getOne("select fn1 from new_staff where id=".$k);
			$fn=array("new_staff_files/".$file_name,"new_staff_files/".$file_name1);
			if ($v==0)
			{
				$subj="Новый сотрудник ".$fio_staff." не добавлен";
				$text="Здравствуйте.<br>";
				$text.="Заявка на добавление нового сотрудника ".$fio_staff." отклонена, сотрудник в базу не добавлен.<br>";
				$text.="Это связано с неполнотой / некорректностью поданных Вами данных.<br>";
				$text.="Для добавления сотрудника в базу Вам необходимо заново заполнить заявку с корректным указанием всей необходимой информации.<br>";
				$text.="Страна: ".$_SESSION["cnt_name"]."<br>";
				$comment[$k]!=''?$text.="Комментарий: <b>".$comment[$k]."</b><br>":null;
				send_mail($email_creator,$subj,$text,null);
				Table_Update("new_staff",array("id"=>$k),null);
			}
			if ($v==1)
			{

				$sql=rtrim(file_get_contents('sql/new_staff_to_spdtree.sql'));
				$params=array(':id'=>$k);
				$sql=stritr($sql,$params);
				$db->query($sql);

				$sql=rtrim(file_get_contents('sql/new_staff_to_limits.sql'));
				$params=array(':id'=>$k);
				$sql=stritr($sql,$params);
				$db->query($sql);

				$sql=rtrim(file_get_contents('sql/new_staff_to_emp_exp.sql'));
				$params=array(':id'=>$k);
				$sql=stritr($sql,$params);
				$db->query($sql);

				$sql=rtrim(file_get_contents('sql/new_staff_to_p_prob_inst.sql'));
				$params=array(':id'=>$k);
				$sql=stritr($sql,$params);
				$db->query($sql);

				$sql=rtrim(file_get_contents('sql/new_staff_to_bud_tn_fil.sql'));
				$params=array(':id'=>$k);
				$sql=stritr($sql,$params);
				$db->query($sql);

				$subj="Добавление нового сотрудника";
				$text="Здравствуйте.<br>";
				$text.="По вашей заявке в базу добавлен новый сотрудник ".$fio_staff.".<br>";
				$text.="Адаптационная программа создана, логин, пароль и адрес для входа на портал - отправлены сотруднику на прямую на корпоративный электронный адрес.<br>";
				$text.="Страна: ".$_SESSION["cnt_name"]."<br>";
				send_mail($email_creator,$subj,$text,null);

				$subj="Личная карточка нового сотрудника";
				$text="Здравствуйте.<br>";
				$text.="У руководителя ".$fio_creator." начал работать новый сотрудник ".$fio_staff."<br>";
				$text.="Просим внести его личную карточку в программу \"Кадры\".<br>";
				$text.="Страна: ".$_SESSION["cnt_name"]."<br>";
				send_mail($pers1,$subj,$text,$fn);
				send_mail($pers2,$subj,$text,$fn);

				$subj="Новый сотрудник";
				$text="Здравствуйте.<br>";
				$text.="У руководителя ".$fio_creator." начал работать новый сотрудник ".$fio_staff."<br>";
				$text.="Просим внести в базу необходимые данные для перечислений.<br>";
				$text.="Страна: ".$_SESSION["cnt_name"]."<br>";
				send_mail($accept1,$subj,$text,null);
				send_mail($accept2,$subj,$text,null);

				$email_new_staff=$db->getOne("select email from new_staff where id=".$k);
				$dolgn=$db->getOne("select pos_name from user_list where tn=(select svideninn from new_staff where id=".$k.")");
				$login=$db->getOne("select svideninn from new_staff where id=".$k);
				$password=$db->getOne("select password from spr_users where tn=(select svideninn from new_staff where id=".$k.")");
				$subj="Работа на корпоративном портале";
				$text="Здравствуйте.<br>";
				$text.="Поздравляем Вас с началом работы в должности ".$dolgn.". Успехов Вам!<br>";
				$text.="Для работы с корпоративным порталом используйте следующие данные:<br>";
				$text.="Адрес сайта:<br>";
				$text.="<a href=\"https://ps.avk.ua\">https://ps.avk.ua</a><br>";
				$text.="<a href=\"https://ps2.avk.ua\">https://ps2.avk.ua</a><br>";
				$text.="Логин: ".$login."<br>";
				$text.="Пароль: ".$password."<br>";
				$text.="Важно! Ваш профиль для входа на портал будет активирован в течение 30-40 минут.<br>";
				$text.="Как работать на портале – изложено в инструкциях к разделам.<br>";
				$text.="Также необходимые консультации Вы сможете получить у непосредственного руководителя и бизнес-тренера.<br>";
				$text.="Страна: ".$_SESSION["cnt_name"]."<br>";
				send_mail($email_new_staff,$subj,$text,null);

				Table_Update("new_staff",array("id"=>$k),array("accepted"=>1));

				$sql=rtrim(file_get_contents('sql/new_staff_childs_change_emp_exp.sql'));
				$params=array(':id'=>$k);
				$sql=stritr($sql,$params);
				$db->query($sql);
			}
		}
	}
}

$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=rtrim(file_get_contents('sql/new_staff.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($data);

foreach ($data as $k=>$v)
{
$p = array(':id' => $v["id"]);

$sql=rtrim(file_get_contents('sql/new_staff_accept_childs.sql'));
$sql=stritr($sql,$p);
$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$data[$k]['childs']=$data1;

$sql=rtrim(file_get_contents('sql/new_staff_accept_bud_fil.sql'));
$sql=stritr($sql,$p);
$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$data[$k]['bud_fil']=$data1;
}

$smarty->assign('new_staff', $data);

$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=rtrim(file_get_contents('sql/dolgn_list.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dolgn_list_all', $data);

$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=rtrim(file_get_contents('sql/bt_list.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);


//echo $sql;

//print_r($data);

$smarty->assign('bt_list', $data);








$smarty->display('new_staff_accept.html');

?>