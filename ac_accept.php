<?

//ses_req();

audit ("открыл форму согласования заявок на проведение АЦ","ac");
InitRequestVar("wait4myaccept",0);


if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["ac_accept"]))
	{
		foreach ($_REQUEST["ac_accept"] as $k=>$v)
		{

			Table_Update("ac_accept",array("id"=>$k),$v);
			$sql=rtrim(file_get_contents('sql/ac_accept_ac_head.sql'));
			$params=array(':accept_id' => $k);
			$sql=stritr($sql,$params);
			$h = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

			/*$sql=rtrim(file_get_contents('sql/ac_accept_ac_executors.sql'));
			$params=array(':accept_id' => $k);
			$sql=stritr($sql,$params);
			$e = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);*/

			if ($v["accepted"]==464261)
			{

				if ($h["ac_ok"]==1)
				{
					$subj="Завершено согласование заявки на проведение АЦ №".$h["id"]./*" по теме: ".$h["head"].*/" от ".$h["created"];
				}
				else
				{
					$subj="Подтверждение заявки на проведение АЦ №".$h["id"]./*" по теме: ".$h["head"].*/" от ".$h["created"];
				}
				audit ("согласовал заявку на проведение АЦ №".$h["id"],"ac");
				echo "<font style=\"color: red;\">Заявка на проведение АЦ №".$h["id"]./*" по теме: ".$h["head"].*/" от ".$h["created"]." Вами подтверждена</font>";
				echo "<br><font style=\"color: red;\">Информирование об этом отправлено:</font><br>";
				if ($h["ac_ok"]==1)
				{
					$sql=rtrim(file_get_contents('sql/ac_accept_mail_yes.sql'));
				}
				else
				{
					$sql=rtrim(file_get_contents('sql/ac_accept_mail_yes_next.sql'));
				}
				$params=array(':accept_id' => $k);
				$sql=stritr($sql,$params);
				$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
				foreach ($data as $k1=>$v1)
				{
					$text="Здравствуйте ".$v1["fio"]."<br>".$fio." согласовал(а) заявку на проведение АЦ №".$h["id"]." ".$now_date_time."<br>";
					if ($h["ac_ok"]==1)
					{
						$text.="<font style=\"color: green; font-weight:bold\">Согласование заявки на проведение АЦ завершено</font><br>";
					}
					else
					{
						$text.="Далее согласование должно пройти у:<br>";
						$sql=rtrim(file_get_contents('sql/ac_accept_mail_yes_other.sql'));
						$params=array(':accept_id' => $k);
						$sql=stritr($sql,$params);
						$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
						foreach ($data1 as $k2=>$v2)
						{
							$text.=$v2["fio"]."<br>";
						}
					}
					$text.="ФИО создателя: ".$h["creator"]."<br>"."Должность создателя: ".$h["creator_pos_name"]."<br>"."Подразделение создателя: ".$h["creator_department_name"]."<br>";
					$text.="ФИО инициатора: ".$h["init"]."<br>"."Должность инициатора: ".$h["init_pos_name"]."<br>"."Подразделение инициатора: ".$h["init_department_name"]."<br>";
					$text.="Вакантная позиция 1: ".$h['vac1']."<br>";
					$text.="Вакантная позиция 2: ".$h['vac1']."<br>";
					$text.="Вакантная позиция 3: ".$h['vac1']."<br>";
					$text.="<a href='https://ps.avk.ua/?action=ac_accept'>Ссылка</a> на реестр документов, ожидающих подтверждение"."<br>";
					$email=$v1["email"];
					echo "<font style=\"color: red;\">".$v1["fio"]."</font>";
					send_mail($email,$subj,$text);
				}
				if ($h["ac_ok"]==1)
				{
					//if (count($e)>0)
					//{
						$text="Вы назначены исполнителем по заявке на проведение АЦ №".$h["id"]./*" по теме ".$h["head"].*/" от ".$h["created"]."<br>";
						$text.="<b>".nl2br($h["place"])."</b><br>";
						$text.="Создателем данной заявки на проведение АЦ выступил(а) ".$h["creator"]."<br>";
						$text.="Инициатором данной заявки на проведение АЦ выступил(а) ".$h["init"]."<br>";
						$text.="Вакантная позиция 1: ".$h['vac1']."<br>";
						$text.="Вакантная позиция 2: ".$h['vac1']."<br>";
						$text.="Вакантная позиция 3: ".$h['vac1']."<br>";
						$text.="Комментарии по заявке на проведение АЦ:<br>";
						$sql=rtrim(file_get_contents('sql/ac_accept_ac_ok_chat.sql'));
						$params=array(':ac_id' => $h["id"]);
						$sql=stritr($sql,$params);
						$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
						foreach ($data1 as $k2=>$v2)
						{
							$text.=$v2["lu"]." ".$v2["fio"].": ".$v2["text"]."<br>";
						}
						/*if (count($e)>1)
						{
							$text.="Исполнителями по данной заявке на проведение АЦ назначены: <br/>";
							foreach ($e as $k2=>$v2)
							{
								$text.=$v2["fio"]." - ".$v2["e_mail"]."<br/>";
							}
						}*/
						$fn=array();
						$sql=rtrim(file_get_contents('sql/ac_files.sql'));
						$params=array(':id'=>$h["id"]);
						$sql=stritr($sql,$params);
						$data = $db->getAssoc($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
						foreach ($data as $k3=>$v3)
						{
							$fn[]="ac_files/".$v3["resume"];
						}
						//foreach ($e as $k2=>$v2)
						//{
							$email=$h['init_mail']/*$v2["e_mail"]*/;
							send_mail($email,$subj,$text,$fn);
						//}
					//}
				}
			}
			if ($v["accepted"]==464262)
			{
				$subj="Отклонение заявку на проведение АЦ №".$h["id"]./*" по теме: ".$h["head"].*/" от ".$h["created"];
				audit ("отклонил заявку на проведение АЦ №".$h["id"],"ac");
				echo "<font style=\"color: red;\">Заявка на проведение АЦ №".$h["id"]./*" по теме: ".$h["head"].*/" от ".$h["created"]." Вами НЕ подтверждена</font>";
				echo "<br><font style=\"color: red;\">Информирование об этом отправлено:</font><br>";
				$sql=rtrim(file_get_contents('sql/ac_accept_mail_no.sql'));
				$params=array(':accept_id' => $k);
				$sql=stritr($sql,$params);
				//echo $sql;
				$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
				//print_r($data);
				foreach ($data as $k1=>$v1)
				{
					$text="Здравствуйте ".$v1["fio"]."<br>".$fio." отклонил(а) заявку на проведение АЦ №".$h["id"]." ".$now_date_time."<br>
					Причина отклонения: ".$v["failure"]."<br>";
					$email=$v1["email"];
					echo "<font style=\"color: red;\">".$v1["fio"]."</font>";
					send_mail($email,$subj,$text);
				}
			}
			if ($v["accepted"]!=464260)
			{
				echo "<hr>";
			}
		}
	}
}


if (isset($_REQUEST["add_chat"]))
{
	if (isset($_REQUEST["ac_accept_chat"]))
	{
		foreach ($_REQUEST["ac_accept_chat"] as $k=>$v)
		{
			if ($v!="")
			{
				Table_Update("ac_chat",array("tn"=>$tn,"ac_id"=>$k,"text"=>$v),array("tn"=>$tn,"ac_id"=>$k,"text"=>$v));
				audit ("оставил по заявке на проведение АЦ №".$k." комментарий: ".$v,"ac");
				//Table_Update("ac_accept_chat",array("acc_id"=>$k,"text"=>$v),array("acc_id"=>$k,"text"=>$v));
				$sql=rtrim(file_get_contents('sql/ac_accept_chat.sql'));
				$params=array(':ac_id' => $k,':tn' => $tn);
				$sql=stritr($sql,$params);
				//echo $sql;
				$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
				//print_r($data);
				foreach ($data as $k1=>$v1)
				{
					$subj="Уточнение по заявке на проведение АЦ №".$v1["ac_id"]./*" по теме: ".$v1["head"].*/" от ".$v1["created"];
					$text="Здравствуйте ".$v1["fio"]."<br>";
					$text.="По заявке на проведение АЦ №".$v1["ac_id"]./*" по теме: ".$v1["head"].*/" от ".$v1["created"]."<br>";
					$text.=$fio." оставил(а) комментарий/уточнение: ".$v."<br>";
					$text.="Просьба ответить на комментарий/уточнение по данной заявке на проведение АЦ в разделе <a href=\"https://ps.avk.ua/?action=ac_accept\">Согласование заявки на проведение АЦ</a>";
					$email=$v1["email"];
					send_mail($email,$subj,$text);
					//send_mail('denis.yakovenko@avk.ua',$subj,$text);
				}
			}
		}
	}
}




$sql=rtrim(file_get_contents('sql/ac_accept_types.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('acat', $data);

$sql=rtrim(file_get_contents('sql/ac_accept.sql'));
$params=array(':tn' => $tn, ":ac_cat"=>0,':wait4myaccept'=>$_REQUEST['wait4myaccept']);
$sql=stritr($sql,$params);
//echo $sql;
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($data as $k=>$v){
$d[$v["id"]]["head"]=$v;
$d[$v["id"]]["comm"][$v["uc_fio"]]=$v;
$d[$v["id"]]["int"][$v["umi_fio"]]=$v;
$d[$v["id"]]["ext"][$v["me_fio"]]=$v;
$d[$v["id"]]["data"][$v["acceptor_tn"]]=$v;
if ($v["chat_id"]!="")
{
$d[$v["id"]]["chat"][$v["chat_id"]]=$v;
}
//$d[$v["id"]]["files"][$v["fn"]]=$v;
}

isset($d) ? $smarty->assign('d', $d) : null;

//print_r($d);

$smarty->display('ac_accept.html');

?>