<?

audit("открыл atd_contr_ag","atd");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("atd_contr_ag", array("id"=>$k),$v);
	}
}

if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_Update("atd_contr_ag", array("id"=>$k),null);
	}
}

if (isset($_REQUEST["send"]))
{
	foreach ($_REQUEST["send"] as $k=>$v)
	{
		$mail=$_REQUEST["data"][$k]["mail"];
		if (isset($v['send'])&&($mail!=''))
		{
			$subj='Информация для доступа к функционалу акции "Дегустация Труфалье Делюкс"';
			$text='Пользователь: '.$v['fio'].'<br />тел.: '.$v['phone'].'<br>';
			$text.='Адрес для входа: <a href="https://ps.avk.ua">https://ps.avk.ua</a><br />Логин: '.$v['login'].'<br />Пароль: '.$v['password'].'.';
			Send_Mail($mail,$subj,$text);
		}
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("atd_contr_ag", $_REQUEST["new"],$_REQUEST["new"]);
}


//ses_req();

$sql=rtrim(file_get_contents('sql/atd_contr_ag.sql'));
$atd_contr_ag = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('atd_contr_ag', $atd_contr_ag);
$smarty->display('atd_contr_ag.html');

?>