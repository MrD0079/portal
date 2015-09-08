<?

//ses_req();

//audit ("открыл форму согласования заявок на проведение активности","bud_ru_zay");
InitRequestVar("wait4myaccept",0);


if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["bud_ru_zay_accept"]))
	{
		foreach ($_REQUEST["bud_ru_zay_accept"] as $k=>$v)
		{

			Table_Update("bud_ru_zay_accept",array("id"=>$k),$v);
			$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_bud_ru_zay_head.sql'));
			$params=array(':accept_id' => $k);
			$sql=stritr($sql,$params);
			$h = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

			if ($v["accepted"]==464261)
			{
				if ($h["bud_ru_zay_ok"]==1)
				{
					// Связь с бюджетами КК
					// После завершения согласования заявки добавляется запись в оперативный план соответствующей сети. 
					$db->query("BEGIN BUD_ZAY2FINPLAN (".$h["id"]."); END;");
					// Для заявок со статьями расходов, у которых в поле "На отчет" задано целочисленное значение больше нуля,
					// в момент согласования заявки автоматически выставляется дата подачи отчета по заявке: $(дата окончания активности) + $(На отчет)
					$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_set_report_data.sql'));
					$p=array(':id' => $h["id"]);
					$sql=stritr($sql,$p);
					$db->query($sql);
				}
				if ($h["bud_ru_zay_ok"]==1)
				{
					$subj="Завершено согласование заявки на проведение активности №".$h["id"]." от ".$h["created"];
				}
				else
				{
					$subj="Подтверждение заявки на проведение активности №".$h["id"]." от ".$h["created"];
				}
				audit ("согласовал заявку на проведение активности №".$h["id"],"bud_ru_zay");
				echo "<font style=\"color: red;\">заявка на проведение активности №".$h["id"]." от ".$h["created"]." Вами подтверждена</font>";
				echo "<br><font style=\"color: red;\">Информирование об этом отправлено:</font><br>";
				if ($h["bud_ru_zay_ok"]==1)
				{
					$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_mail_yes.sql'));
				}
				else
				{
					$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_mail_yes_next.sql'));
				}
				$params=array(':accept_id' => $k);
				$sql=stritr($sql,$params);
				$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
				foreach ($data as $k1=>$v1)
				{
					$text="Здравствуйте ".$v1["fio"]."<br>".$fio." согласовал(а) заявку на проведение активности №".$h["id"]." ".$now_date_time."<br>";
					if ($h["bud_ru_zay_ok"]==1)
					{
						$text.="<font style=\"color: green; font-weight:bold\">Согласование заявки на проведение активности завершено</font><br>";
					}
					else
					{
						$text.="Далее согласование должно пройти у:<br>";
						$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_mail_yes_other.sql'));
						$params=array(':accept_id' => $k);
						$sql=stritr($sql,$params);
						$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
						foreach ($data1 as $k2=>$v2)
						{
							$text.=$v2["fio"]."<br>";
						}
					}
					$text.="ФИО инициатора: ".$h["creator"]."<br>"."Должность инициатора: ".$h["creator_pos_name"]."<br>"."Подразделение инициатора: ".$h["creator_department_name"]."<br>";
					$text.="<a href='https://ps.avk.ua/?action=bud_ru_zay_accept'>Ссылка</a> на реестр документов, ожидающих подтверждение"."<br>";
					$email=$v1["email"];
					echo "<font style=\"color: red;\">".$v1["fio"]."</font>";
					send_mail($email,$subj,$text);
				}
			}
			if ($v["accepted"]==464262)
			{
				$subj="Отклонение заявки на проведение активности №".$h["id"]." от ".$h["created"];
				audit ("отклонил заявку на проведение активности №".$h["id"],"bud_ru_zay");
				echo "<font style=\"color: red;\">заявка на проведение активности №".$h["id"]." от ".$h["created"]." Вами НЕ подтверждена</font>";
				echo "<br><font style=\"color: red;\">Информирование об этом отправлено:</font><br>";
				$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_mail_no.sql'));
				$params=array(':accept_id' => $k);
				$sql=stritr($sql,$params);
				//echo $sql;
				$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
				//print_r($data);
				foreach ($data as $k1=>$v1)
				{
					$text="Здравствуйте ".$v1["fio"]."<br>".$fio." отклонил(а) заявку на проведение активности №".$h["id"]." ".$now_date_time."<br>
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
	if (isset($_REQUEST["bud_ru_zay_accept_chat"]))
	{
		foreach ($_REQUEST["bud_ru_zay_accept_chat"] as $k=>$v)
		{
			if ($v!="")
			{
				Table_Update("bud_ru_zay_chat",array("tn"=>$tn,"z_id"=>$k,"text"=>$v),array("tn"=>$tn,"z_id"=>$k,"text"=>$v));
				audit ("оставил по заявке на проведение активности №".$k." комментарий: ".$v,"bud_ru_zay");
				//Table_Update("bud_ru_zay_accept_chat",array("acc_id"=>$k,"text"=>$v),array("acc_id"=>$k,"text"=>$v));
				$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_chat.sql'));
				$params=array(':z_id' => $k,':tn' => $tn);
				$sql=stritr($sql,$params);
				//echo $sql;
				$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
				//print_r($data);
				foreach ($data as $k1=>$v1)
				{
					$subj="Уточнение по заявке на проведение активности №".$v1["z_id"]." от ".$v1["created"];
					$text="Здравствуйте ".$v1["fio"]."<br>";
					$text.="По заявке на проведение активности №".$v1["z_id"]." от ".$v1["created"]."<br>";
					$text.=$fio." оставил(а) комментарий/уточнение: ".$v."<br>";
					$text.="Просьба ответить на комментарий/уточнение по данной заявке на проведение активности в разделе <a href=\"https://ps.avk.ua/?action=bud_ru_zay_accept\">Согласование заявок на проведение активности</a>";
					$email=$v1["email"];
					send_mail($email,$subj,$text);
				}
			}
		}
	}
}




$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_types.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_ru_zay_accept_types', $data);

$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept.sql'));
$params=array(':tn' => $tn,':wait4myaccept'=>$_REQUEST['wait4myaccept']);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($data as $k=>$v){
$d[$v["id"]]["head"]=$v;
$d[$v["id"]]["data"][$v["acceptor_tn"]]=$v;
if ($v["chat_id"]!="")
{
$d[$v["id"]]["chat"][$v["chat_id"]]=$v;
}
}

if (isset($d))
{
foreach ($d as $k=>$v)
{
	$sql=rtrim(file_get_contents('sql/bud_ru_zay_get_ff.sql'));
	$params=array(':z_id' => $k);
	$sql=stritr($sql,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($data as $k1=>$v1)
	{
		if ($v1["type"]=="file")
		{
			$data[$k1]["val_file"]=explode("\n",$v1["val_file"]);
		}
		if ($v1['type']=='list')
		{
			$sql=$db->getOne('SELECT get_item FROM bud_ru_ff_subtypes WHERE id = (SELECT subtype FROM bud_ru_ff WHERE id = '.$v1['ff_id'].')');
			$params[':id'] = $v1['val_list'];
			$sql=stritr($sql,$params);
			$list = $db->getOne($sql);
			$data[$k1]['val_list_name'] = $list;
		}
	}
	include "bud_ru_zay_formula.php";
	$d[$k]["ff"]=$data;
}
}

isset($d) ? $smarty->assign('d', $d) : null;


//print_r($d);

$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_total.sql'));
$params=array(':tn' => $tn,':wait4myaccept'=>$_REQUEST['wait4myaccept']);
$sql=stritr($sql,$params);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d1', $data);

//print_r($d);

$smarty->display('bud_ru_zay_accept.html');

?>