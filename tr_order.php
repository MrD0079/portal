<?

audit ("открыл форму создания заявки на тренинг","tr");

InitRequestVar('notPass','false');

//ses_req();

$p = array();
$p[':tn'] = $tn;
$p[':dpt_id'] = $_SESSION["dpt_id"];

if (isset($_REQUEST["SendNBT"])&&isset($_REQUEST["table"]))
{
	$p[':loc'] = $_REQUEST["tr_loc"];
	$p[':dt_start'] = "'".$_REQUEST["dt"]."'";

	$sql=rtrim(file_get_contents('sql/tr_order_exist.sql'));
	$sql=stritr($sql,$p);
	$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$r = $db->query($sql);

	if ($r->numRows()==0)
	{
		$order = get_new_id();
		$keys = array("id" => $order);
		$vals = array(
			"tn" => $tn,
			"tr" => $_REQUEST["tr"],
			"dt_start" => OraDate2MDBDate($_REQUEST["dt"]),
			"loc" => $_REQUEST["tr_loc"]
		);
		isset($_REQUEST["text"]) ? $vals["text"] = $_REQUEST["text"] : null;
		Table_Update("tr_order_head",$keys,$vals);
		foreach ($_REQUEST["table"] as $k => $v)
		{
			$keys = array(
				"head" => $order,
				"tn" => $v["tn"]
			);
			$vals = array(
				"manual" => $v["manual"]
			);
			Table_Update("tr_order_body",$keys,$vals);
		}

		echo "<h3 style='color:red'>Ваша заявка добавлена и отправлена на рассмотрение НБТ. Просмотреть и отредактировать ее Вы можете на форме «Редактирование заявок на проведение тренинга».</h3>";

		$sql=rtrim(file_get_contents('sql/tr_order_exist.sql'));
		$sql=stritr($sql,$p);
		$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

		$sql=rtrim(file_get_contents('sql/tr_order_emails.sql'));
		$sql=stritr($sql,$p);
		$e=$db->getCol($sql);
		$emails=join($e,',');
		$subj="Подтверждение проведения тренинга";
		$text="
			Тренер ".$d["fio"]." подал заявку на проведение тренинга - ".$d["name"].".<br />
			Дата проведения тренинга - ".$d["dt_start_t"].".<br />
			Место проведения - ".$d["loc_name"].". <br />
			Количество участников - ".$d["stud_cnt"].". <br />
			Комментарий - ".$d["text"].".
			";
		send_mail($emails,$subj,$text);
	}
	else
	{
		echo "<h3 style='color:red'>На указанную дату проведение тренинга на выбранной локации невозможно,<br>так как запланировано проведение тренинга - ".$d["name"].",<br>тренер - ".$d["fio"]."</h3>";
	}
}

$sql=rtrim(file_get_contents('sql/tr.sql'));
$sql=stritr($sql,$p);
$tr = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr', $tr);

$sql=rtrim(file_get_contents('sql/tr_loc.sql'));
$sql=stritr($sql,$p);
$tr_loc = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr_loc', $tr_loc);

$sql=rtrim(file_get_contents('sql/countries.sql'));
$sql=stritr($sql,$p);
$cnt = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('cnt', $cnt);

$sql=rtrim(file_get_contents('sql/pos_list_actual_full.sql'));
$sql=stritr($sql,$p);
$pos = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos', $pos);

$sql=rtrim(file_get_contents('sql/parents_full.sql'));
$sql=stritr($sql,$p);
$parents = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('parents', $parents);

if (isset($_REQUEST["form_list"]))
{
	$p[':tr_kod'] = $_REQUEST["tr"];
	$p[':tr_ok'] = Bool2Int($_REQUEST["notPass"],1);
	$p[':dt_start'] = "'".$_REQUEST["dt"]."'";

	if (isset($_REQUEST["country"]))
	{
		$country = join($_REQUEST["country"],',');
		//echo $country;
		$p[':country'] = $country;
	}
	else
	{
		$p[':country'] = '0';
	}

	if (isset($_REQUEST["pos"]))
	{
		$pos = join($_REQUEST["pos"],',');
		//echo $pos;
		$p[':pos'] = $pos;
	}
	else
	{
		$p[':pos'] = '0';
	}

	if (isset($_REQUEST["ruk"]))
	{
		$ruk = join($_REQUEST["ruk"],',');
		//echo $ruk;
		$p[':ruk'] = $ruk;
	}
	else
	{
		$p[':ruk'] = '0';
	}

	$sql=rtrim(file_get_contents('sql/tr_order_users.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$tru = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('tru', $tru);

	$sql = rtrim(file_get_contents('sql/tr_order_users_add.sql'));
	$sql=stritr($sql,$p);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('trua', $data);

}

$smarty->display('tr_order.html');

?>