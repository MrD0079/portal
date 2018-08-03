<?

audit ("открыл форму результат тренинга","tr");



$p = array();
$p[':id'] = $_REQUEST["id"];

if (isset($_REQUEST["a"]))
{
	foreach ($_REQUEST["a"] as $k => $v)
	{
		foreach ($v as $k1 => $v1)
		{
			Table_Update("tr_order_body",array("id" => $k),$v);
		}
	}
}

if (isset($_REQUEST["tr"]))
{
	Table_Update("tr_order_head",array("id" => $_REQUEST["id"]),array("completed" => $_REQUEST["tr"]));

	if ($_REQUEST["tr"]==1)
	{
		$sql=rtrim(file_get_contents('sql/tr_list_order.sql'));
		$sql=stritr($sql,$p);
		$h = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('h', $h);

		$sql=rtrim(file_get_contents('sql/tr_report_parents.sql'));
		$sql=stritr($sql,$p);
		$d2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

		foreach ($d2 as $k1 => $v1)
		{
			/* Прямые руководители сотрудников, приглашаемых на тренинг (участников), получают информационное сообщение от системы:*/
	        
			$subj="ОС по участию в тренинге '".$h["name"]."' сотрудника ".$v1["c_fio"];
			$text="Здравствуйте, ".$v1["p_fio"].".<br /><br />
			".$h["fio"]." в качестве тренера, проводившего данный тренинг ".$h["dt_start_t"].", оставил следующую обратную связь по участнику: <br />
			".nl2br($v1["os"]).".";
			send_mail($v1["p_mail"],$subj,$text);
	        
			/* участникам тренинга отправляется письмо от информационной системы */
	        
			$subj="Прохождение тестирования по тренингу '".$h["name"]."'.";
			$text="Здравствуйте, ".$v1["c_fio"].". Вы были участником тренинга '".$h["name"]."' ".$h["dt_start_t"].".<br>
			Вам необходимо заполнить ОС по пройденному тренингу и пройти посттренинговое тестирование.<br>
			Для этого пройдите по данной <a href=\"https://ps.avk.ua/?action=tr_os\">ссылке</a>, либо зайдите через корпоративный портал в раздел «Команда / Обучение / ОС по тренингу БТ и тестирование».<br /><br />
			<h3><b>Ссылка будет активна в течение 48 часов с момента получения данного сообщения!<br />
			Помните, у вас есть только одна попытка пройти тест. Начав тестирование, вы должны пройти его до конца!</b></h3>";
			send_mail($v1["c_mail"],$subj,$text);
		}


		/* сотрудникам из «Переменной среды» pers2 ТОЙ СТРАНЫ, В КОТОРОЙ ЗАКРЕПЛЕН УЧАСТНИК ТРЕНИНГА отправляется информационное сообщение */

		$sql=rtrim(file_get_contents('sql/tr_report_pers2.sql'));
		$sql=stritr($sql,$p);
		$p2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

		foreach ($p2 as $pk=>$pv)
		{
			$p2d[$pv["e_mail"]][$pv["fio"]]=$pv["pos_name"];
		}

		$subj="Проведен тренинг '".$h["name"]."'.";


		if (isset($p2d))
		{
			foreach ($p2d as $pk2=>$pv2)
			{
				$text='Проведен тренинг '.$h["name"].'. <br />
				Дата проведения - '.$h["dt_start_t"].', дата окончания – '.$h["tr_end"].' <br />
				Тренер - '.$h["fio"].'<br />
				Место проведения тренинга - '.$h["loc_name"].'. <br />
				Комментарии - '.nl2br($h['text']).'<br />
				Список участников: <br />';
				foreach ($pv2 as $pk3=>$pv3)
				{
					$text.=$pk3.' - '.$pv3.'<br />';
				}
				$text.='Просьба внести информацию в базу «Персонал».';
				send_mail($pk2,$subj,$text);
			}
		}

		/* письмо высылается также сотрудникам из списков accept1 и accept2 */

		$sql=rtrim(file_get_contents('sql/tr_report_accept12.sql'));
		$sql=stritr($sql,$p);
		$a2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

		foreach ($a2 as $ak=>$av)
		{
			$a2d[$av["e_mail"]][$av["fio"]]=$av["pos_name"];
		}

		$subj="Проведен тренинг '".$h["name"]."'.";

		if (isset($a2d))
		{
			foreach ($a2d as $ak2=>$av2)
			{
				$text='Проведен тренинг '.$h["name"].'. <br />Тренер: '.$h["fio"].'. <br />Место проведения тренинга '.$h["loc_name"].'. <br />Дата проведения - '.$h["dt_start_t"].', дата окончания – '.$h["tr_end"].' <br />Список участников: <br />';
				foreach ($av2 as $ak3=>$av3)
				{
					$text.=$ak3.' - '.$av3.'<br />';
				}
				$text.='Просьба внести информацию в базу «Персонал» и учесть при проверке командировочных расходов.';
				send_mail($ak2,$subj,$text);
			}
		}

		/* включаем тест тем, кто присутствовал и еще не проходил тест */
		Table_Update("tr_order_body",array("head" => $_REQUEST["id"],"completed" => 1,"test" => 0),array("test" => 1));
	}
}


/* повторное включение теста */

if (isset($_REQUEST["b"]))
{
	foreach ($_REQUEST["b"] as $k => $v)
	{
		Table_Update("tr_order_body",array("id" => $k),array("test" => 1));
	}
}

$sql=rtrim(file_get_contents('sql/tr_list_order.sql'));
$sql=stritr($sql,$p);
$h = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('h', $h);

$sql=rtrim(file_get_contents('sql/tr_report.sql'));
$sql=stritr($sql,$p);
$tru = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tru', $tru);

$smarty->display('tr_report.html');

?>