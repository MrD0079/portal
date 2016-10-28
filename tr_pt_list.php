<?

InitRequestVar("sd",$_SESSION["month_list"]);
InitRequestVar("ed",$_SESSION["month_list"]);
InitRequestVar("tr",0);
InitRequestVar("tr_tn",0);
InitRequestVar("tr_loc",0);

$p = array();
$p[':tn'] = $tn;
$p[':dpt_id'] = $_SESSION["dpt_id"];
$p[':tr_tn'] = $_REQUEST["tr_tn"];
$p[':tr_loc'] = $_REQUEST["tr_loc"];
$p[':tr'] = $_REQUEST["tr"];
$p[':sd'] = "'".$_REQUEST["sd"]."'";
$p[':ed'] = "'".$_REQUEST["ed"]."'";

audit("открыл список заявок на тренинг","tr");




//ses_req();


if (isset($_REQUEST["save"])||isset($_REQUEST["ok_primary_retry"]))
{
	InitRequestVar("generate",'true');

	if (isset($_REQUEST["del"]))
	{
		foreach($_REQUEST["del"] as $k=>$v)
		{
			Table_Update("tr_pt_order_head",array("id"=>$v),null);
			audit ("удалил заявку на тренинг №".$v,"tr");
		}
	}

	if (isset($_REQUEST["ok_primary_retry"]))
	{
		if (isset($_REQUEST["ok_primary_retry_id"]))
		{
				$p[':id'] = $_REQUEST["ok_primary_retry_id"];

				$sql=rtrim(file_get_contents('sql/tr_pt_list_order.sql'));
				$sql=stritr($sql,$p);
				$d1 = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

				//Прямые руководители сотрудников, приглашаемых на тренинг (участников), получают информационное сообщение от системы:

				$subj="Подтверждение участия вашего подчиненного в тренинге - ".$d1["name"].".";

				$sql=rtrim(file_get_contents('sql/tr_pt_list_order_ok_primary_parents.sql'));
				$sql=stritr($sql,$p);

				$d2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

				foreach ($d2 as $k1 => $v1)
				{
					$text="Здравствуйте, ".$v1["p_fio"].".<br /><br />
					Ваш подчиненный ".$v1["c_fio"]." приглашен для участия в тренинге - ".$d1["name"].". <br />
					Тренер: ".$d1["fio"].". <br />
					Дата проведения тренинга: ".$d1["dt_start_t"].". <br />
					Продолжительность тренинга, дней: ".$d1["days"].". <br />
					Место проведения тренинга: ".$d1["loc_name"].". <br /><br />
					В случае, если Вы считаете нецелесообразным участие сотрудника в указанном тренинге, Вам необходимо в срок до ".$d1["warn48"]." связаться с тренером посредством мобильной связи / электронной почты и сообщить ему о причинах Вашего решения.<br> <b>
					В случае, если до указанного срока Вы не связались с тренером и не сообщили ему о неучастии подчиненного сотрудника в тренинге, ответственность ложится на Вас, а в ходе расчета заработной платы с Вас будут удержаны средства, потраченные на организацию участия подчиненного сотрудника в тренинге.</b>";
					send_mail($v1["p_mail"],$subj,$text);
				}
		}
	}

	if (isset($_REQUEST["ok_primary"]))
	{
		foreach($_REQUEST["ok_primary"] as $k=>$v)
		{
			Table_Update("tr_pt_order_head",array("id"=>$k),array("ok_primary"=>1));


				$p[':id'] = $k;

				$sql=rtrim(file_get_contents('sql/tr_pt_list_order.sql'));
				$sql=stritr($sql,$p);
				$d1 = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

				//Тренер, создавший заявку, получает информационное сообщение от системы:

				$subj="Согласование тренинга - ".$d1["name"].", Дата проведения тренинга - ".$d1["dt_start_t"];
				$text="
				Здравствуйте, ".$d1["fio"].".<br /><br />
				Ваша заявка на проведение тренинга подтверждена. <br />
				Руководителям сотрудников, приглашенных на тренинг, отправлен запрос на подтверждение участия подчиненных. <br />
				Подтверждение руководителей должно быть вам предоставлено в срок ".$d1["warn48"].". <br />
				После этого вам необходимо в течение одного рабочего дня внести корректировки в состав участников тренинга.";

				$emails=$d1["e_mail"];
				send_mail($emails,$subj,$text);

				//Прямые руководители сотрудников, приглашаемых на тренинг (участников), получают информационное сообщение от системы:

				$subj="Подтверждение участия вашего подчиненного в тренинге - ".$d1["name"].".";

				$sql=rtrim(file_get_contents('sql/tr_pt_list_order_ok_primary_parents.sql'));
				$sql=stritr($sql,$p);

				$d2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

				foreach ($d2 as $k1 => $v1)
				{
					$text="Здравствуйте, ".$v1["p_fio"].".<br /><br />
					Ваш подчиненный ".$v1["c_fio"]." приглашен для участия в тренинге - ".$d1["name"].". <br />
					Тренер: ".$d1["fio"].". <br />
					Дата проведения тренинга: ".$d1["dt_start_t"].". <br />
					Продолжительность тренинга, дней: ".$d1["days"].". <br />
					Место проведения тренинга: ".$d1["loc_name"].". <br /><br />
					В случае, если Вы считаете нецелесообразным участие сотрудника в указанном тренинге, Вам необходимо в срок до ".$d1["warn48"]." связаться с тренером посредством мобильной связи / электронной почты и сообщить ему о причинах Вашего решения.<br> <b>
					В случае, если до указанного срока Вы не связались с тренером и не сообщили ему о неучастии подчиненного сотрудника в тренинге, ответственность ложится на Вас, а в ходе расчета заработной платы с Вас будут удержаны средства, потраченные на организацию участия подчиненного сотрудника в тренинге.</b>";
					send_mail($v1["p_mail"],$subj,$text);
				}

				// Через 96 часов с момента выставления чекбокса «Подтверждение / Первичное» НБТ приходит напоминалка от информационной системы:
				// Тема: «»
				// Текст: «Подошел срок для финального подтверждения списка участников тренинга «$(название тренинга)».
				//Дата проведения – $дата,
				//Тренер – $тренер,
				//Локация – $локация.
				//<a href="https://ps.avk.ua/?action=tr_pt_list">Перейти</a> на страницу подтверждения».

				$sql=rtrim(file_get_contents('sql/tr_pt_list_order_nbt_emails.sql'));
				$sql=stritr($sql,$p);
				$e=$db->getCol($sql);
				$emails=join($e,',');
				$subj="Подошел срок для финального подтверждения списка участников тренинга - ".$d1["name"].", Дата проведения тренинга - ".$d1["dt_start_t"];
				$text="Подошел срок для финального подтверждения списка участников тренинга - ".$d1["name"].". <br />
				Тренер: ".$d1["fio"].". <br />
				Дата проведения тренинга: ".$d1["dt_start_t"].". <br />
				Продолжительность тренинга, дней: ".$d1["days"].". <br />
				Место проведения тренинга: ".$d1["loc_name"].". <br /><br />
				<a href=\"https://ps.avk.ua/?action=tr_pt_list\">Перейти</a> на страницу подтверждения.";

				$emails=stritr($emails,array("'"=>"''"));
				$subj=stritr($subj,array("'"=>"''"));
				$text=stritr($text,array("'"=>"''"));
				$sql="BEGIN add_job (96, 'DECLARE i INTEGER; BEGIN SELECT ok_final INTO i FROM tr_pt_order_head WHERE id = ".$k."; IF i <> 1 THEN PERSIK.PR_SENDMAIL (''".$emails."'', ''".$subj."'', ''".$text."''); END IF;END;'); END;";
				$db->query($sql);
		}
	}

	if (isset($_REQUEST["ok_final"]))
	{
		foreach($_REQUEST["ok_final"] as $k=>$v)
		{
			if ($v!='')
			{
				Table_Update("tr_pt_order_head",array("id"=>$k),array("ok_final"=>$v));
			}

			$p[':id'] = $k;

			$sql=rtrim(file_get_contents('sql/tr_pt_list_order.sql'));
			$sql=stritr($sql,$p);
			$d1 = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

			if (($v==1)&&($d1["days2tr"]>0))
			{

				/* Тренер, создавший заявку, и НБТ получают информационное сообщение от системы: */

				$sql=rtrim(file_get_contents('sql/tr_pt_list_order_chat.sql'));
				$sql=stritr($sql,$p);
				$dc = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

				$chat='';
				if (count($dc)>0)
				{
					foreach ($dc as $kc=>$vc)
					{
						$chat.=$vc['lu'].' '.$vc['fio'].': '.$vc['text'].'<br>';
					}
				}

				$p[':creator_tn'] = $d1["tn"];

				$sql=rtrim(file_get_contents('sql/tr_pt_list_order_emails.sql'));
				$sql=stritr($sql,$p);
				$e=$db->getCol($sql);
				$emails=join($e,',');
				$subj="Приглашение участников на тренинг - ".$d1["name"].", Дата проведения тренинга - ".$d1["dt_start_t"];

				$text="Согласование участников тренинга завершено, на тренинг приглашены:<br />";

				$sql=rtrim(file_get_contents('sql/tr_pt_list_order_ok_final_childs.sql'));
				$sql=stritr($sql,$p);

				$d2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

				foreach ($d2 as $k1 => $v1)
				{
					$text.=$v1["c_fio"]." - ".$v1["c_pos"]." <br />";
				}

				$text.="Место проведения тренинга: ".$d1["loc_name"].". <br /><br />";

				send_mail($emails,$subj,$text);

				/* Прямые руководители сотрудников, приглашаемых на тренинг (участников), получают информационное сообщение от системы:*/

				$sql=rtrim(file_get_contents('sql/tr_pt_list_order_ok_primary_parents.sql'));
				$sql=stritr($sql,$p);

				$d2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

				foreach ($d2 as $k1 => $v1)
				{
					$subj="Ваш подчиненный ".$v1["c_fio"]." приглашен для участия в тренинге - ".$d1["name"].".";
					$text="Здравствуйте, ".$v1["p_fio"].".<br /><br />
					Ваш подчиненный ".$v1["c_fio"]." приглашен для участия в тренинге - ".$d1["name"].". <br />
					Тренер: ".$d1["fio"].". <br />
					Дата проведения тренинга: ".$d1["dt_start_t"].". <br />
					Место проведения тренинга: ".$d1["loc_name"].". <br /><br />
					Начало тренинга: ".$parameters['tr_time_start']['val_string']." (по местному времени).
					Окончание тренинга: ".$d1["tr_end"].", ".$parameters['tr_time_end']['val_string']." (по местному времени). <br /><br />
					Вам необходимо обеспечить и проконтролировать присутствие сотрудника на тренинге.";
					$text.="<br>";
					$text.="Комментарий к тренингу:<br>".$d1["text"]."<br>";
					send_mail($v1["p_mail"],$subj,$text);
				}
			}
		}
	}

	if (isset($_REQUEST["chat"]))
	{
		foreach($_REQUEST["chat"] as $k=>$v)
		{
			if ($v!='')
			{
				$keys = array("head"=>$k,"tn"=>$tn,"text"=>$v);
				Table_Update("tr_pt_order_chat",$keys,$keys);

				/* При оставлении комментария сообщение от системы об этом получает тренер и НБТ. Тема сообщения: «Комментарий к заявке на проведение тренинга $тренинг, дата проведения $дата. Текст: $комментарий. */

				$p[':id'] = $k;

				$sql=rtrim(file_get_contents('sql/tr_pt_list_order.sql'));
				$sql=stritr($sql,$p);
				$d1 = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

				$p[':creator_tn'] = $d1["tn"];

				$sql=rtrim(file_get_contents('sql/tr_pt_list_order_emails.sql'));
				$sql=stritr($sql,$p);
				$e=$db->getCol($sql);
				$emails=join($e,',');
				$subj="Комментарий к заявке на проведение тренинга - ".$d1["name"].", Дата проведения тренинга - ".$d1["dt_start_t"];
				$text=$v;
				send_mail($emails,$subj,$text);
			}
		}
	}
}

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql=rtrim(file_get_contents('sql/tr_tn.sql'));
$sql=stritr($sql,$p);
$tr_tn = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr_tn', $tr_tn);

$sql=rtrim(file_get_contents('sql/tr_pt.sql'));
$sql=stritr($sql,$p);
$tr = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr', $tr);

$sql=rtrim(file_get_contents('sql/tr_loc.sql'));
$sql=stritr($sql,$p);
$tr_loc = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr_loc', $tr_loc);

if (isset($_REQUEST["generate"]))
{
	$sql=rtrim(file_get_contents('sql/tr_pt_list.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$tr_pt_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	//var_dump($tr_pt_list);
	foreach($tr_pt_list as $k=>$v)
	{
		$d[$v["id"]]["head"]=$v;
		$v["stud_tn"]!='' ? $d[$v["id"]]["body"][$v["stud_tn"]]=$v : null;
		$v["c_id"]!='' ?  $d[$v["id"]]["chat"][$v["c_id"]]=$v : null;
	}
	//print_r($d);
	isset($d)?$smarty->assign('d', $d):null;
}


//ses_req();

$smarty->display('tr_pt_list.html');

?>