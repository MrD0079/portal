<?




InitRequestVar("sd",$_SESSION["month_list"]);
InitRequestVar("ed",$_SESSION["month_list"]);
InitRequestVar("pos",0);
InitRequestVar("dc_tn",0);
InitRequestVar("dc_loc",0);

$p = array();
$p[':tn'] = $tn;
$p[':dpt_id'] = $_SESSION["dpt_id"];
$p[':pos'] = $_REQUEST["pos"];
$p[':dc_tn'] = $_REQUEST["dc_tn"];
$p[':dc_loc'] = $_REQUEST["dc_loc"];
$p[':sd'] = "'".$_REQUEST["sd"]."'";
$p[':ed'] = "'".$_REQUEST["ed"]."'";

audit("открыл список заявок на девелопмент-центр","tr");

if (isset($_REQUEST["save"])||isset($_REQUEST["ok_primary_retry"]))
{
	InitRequestVar("generate",'true');

	if (isset($_REQUEST["del"]))
	{
		foreach($_REQUEST["del"] as $k=>$v1)
		{
			Table_Update("dc_order_head",array("id"=>$v1),null);
			audit ("удалил заявку на тренинг №".$v1,"tr");
		}
	}

	if (isset($_REQUEST["ok_primary_retry"]))
	{
		if (isset($_REQUEST["ok_primary_retry_id"]))
		{
				$p[':id'] = $_REQUEST["ok_primary_retry_id"];

				$sql=rtrim(file_get_contents('sql/dc_list_order.sql'));
				$sql=stritr($sql,$p);
				$d1 = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

		$sql=rtrim(file_get_contents('sql/dc_order_emails_childs.sql'));
		$sql=stritr($sql,$p);
		$c = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

		foreach ($c as $k=>$v1)
		{
			$subj="Приглашение на девелопмент-центр, ".$d1["dt_start_t"];
			$text="
				Здравствуйте, ".$v1["c_fio"].".<br>
				Вы приглашены ".$d1["dt_start_t"]." для участия в девеломпент-центре.<br>
				Место проведения - ".$d1["loc_name"].". <br>
				<a href=\"".$d1["url"]."\">Ссылка на карту</a><br>
				Адрес - ".$d1["addr"].". <br>
				Комментарии - ".$d1["loc_text"].". <br>
				".$parameters['dc_invitation']['val_string']."
				<p>Комментарий - ".$d1["text"]."</p>
				";
			send_mail($v1["c_mail"],$subj,$text);
		}

		$sql=rtrim(file_get_contents('sql/dc_order_emails_parents.sql'));
		$sql=stritr($sql,$p);
		$pr = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

		foreach ($pr as $k=>$v1)
		{
			$subj="Приглашение подчиненного для участия в девелопмент-центре, ".$d1["dt_start_t"];
			$text="
				Здравствуйте, ".$v1["p_fio"].".<br>
				Ваш подчиненный ".$v1["c_fio"]." приглашен ".$d1["dt_start_t"]." для участия в девеломпент-центре.<br>
				Место проведения - ".$d1["loc_name"].". <br>
				Комментарии - ".$d1["loc_text"].". <br>
				<p>Комментарий - ".$d1["text"]."</p>
				По возникшим вопросам - обращайтесь к начальнику департамента персонала.
				";
			send_mail($v1["p_mail"],$subj,$text);
		}






		}
	}

}

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql=rtrim(file_get_contents('sql/pos_list_actual_full.sql'));
$sql=stritr($sql,$p);
$pos = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos', $pos);

$sql=rtrim(file_get_contents('sql/dc_loc.sql'));
$sql=stritr($sql,$p);
$dc_loc = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dc_loc', $dc_loc);

if (isset($_REQUEST["generate"]))
{
	$sql=rtrim(file_get_contents('sql/dc_list.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$dc_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	//var_dump($dc_list);
	foreach($dc_list as $k=>$v)
	{
		$d[$v["id"]]["head"]=$v;
		$v["stud_tn"]!='' ? $d[$v["id"]]["body"][$v["stud_tn"]]=$v : null;
	}
	//print_r($d);
	isset($d)?$smarty->assign('d', $d):null;
}




$smarty->display('dc_list.html');

?>