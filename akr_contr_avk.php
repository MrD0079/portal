<?

audit("открыл akr_contr_avk","akr");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("akr_contr_avk", array("id"=>$k),$v);
	}
}

if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_Update("akr_contr_avk", array("id"=>$k),null);
	}
}

if (isset($_REQUEST["send"]))
{
	foreach ($_REQUEST["send"] as $k=>$v)
	{
		$mail=$_REQUEST["data"][$k]["mail"];
		if (isset($v['send'])&&($mail!=''))
		{
			$subj='Информация для доступа к функционалу акции "Дегустация Креско"';
			$text='Пользователь: '.$v['fio'].'<br />тел.: '.$v['phone'].'<br>';
			$text.='Адрес для входа: <a href="https://ps.avk.ua">https://ps.avk.ua</a><br />Логин: '.$v['login'].'<br />Пароль: '.$v['password'].'';
			Send_Mail($mail,$subj,$text);
		}
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("akr_contr_avk", $_REQUEST["new"],$_REQUEST["new"]);
}


//ses_req();

$sql=rtrim(file_get_contents('sql/akr_contr_avk.sql'));
$akr_contr_avk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('akr_contr_avk', $akr_contr_avk);
$smarty->display('akr_contr_avk.html');

?>