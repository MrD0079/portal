<?

audit ("������ ����� �������� ������ �� �������","tr");

//ses_req();

$p = array();
$p[':tn'] = $tn;
$p[':dpt_id'] = $_SESSION["dpt_id"];

if (isset($_REQUEST["SendNBT"])&&isset($_REQUEST["table"]))
{
	$p[':loc'] = $_REQUEST["dc_loc"];
	$p[':dt_start'] = "'".$_REQUEST["dt"]."'";

	$sql=rtrim(file_get_contents('sql/dc_order_exist.sql'));
	$sql=stritr($sql,$p);
	$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$r = $db->query($sql);

	if ($r->numRows()==0)
	{
		$order = get_new_id();
		$p[':id'] = $order;
		$keys = array("id" => $order);
		$vals = array(
			"tn" => $tn,
			"dt_start" => OraDate2MDBDate($_REQUEST["dt"]),
			"loc" => $_REQUEST["dc_loc"]
		);
		isset($_REQUEST["text"]) ? $vals["text"] = $_REQUEST["text"] : null;
		Table_Update("dc_order_head",$keys,$vals);
		foreach ($_REQUEST["table"] as $k => $v)
		{
			$keys = array(
				"head" => $order,
				"tn" => $v["tn"]
			);
			$vals = array(
				"manual" => $v["manual"]
			);
			Table_Update("dc_order_body",$keys,$vals);
		}

		echo "<h3 style='color:red'>���� ������ ���������. ����������� � ��������������� �� �� ������ �� ����� ��������������� ������ �� ���������� �����������-������.</h3>";

		$sql=rtrim(file_get_contents('sql/dc_order_exist.sql'));
		$sql=stritr($sql,$p);
		$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

		$sql=rtrim(file_get_contents('sql/dc_order_emails_childs.sql'));
		$sql=stritr($sql,$p);
		$c = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

		foreach ($c as $k=>$v)
		{
			$subj="����������� �� �����������-�����, ".$d["dt_start_t"];
			$text="
				������������, ".$v["c_fio"].".<br>
				�� ���������� ".$d["dt_start_t"]." ��� ������� � �����������-������.<br>
				����� ���������� - ".$d["loc_name"].". <br>
				<a href=\"".$d["url"]."\">������ �� �����</a><br>
				����� - ".$d["addr"].". <br>
				����������� - ".$d["loc_text"].". <br>
				".$parameters['dc_invitation']['val_string']."
				<p>����������� - ".$d["text"]."</p>
				";
			send_mail($v["c_mail"],$subj,$text);
			//send_mail('denis.yakovenko@avk.ua',$subj,$text);
		}

		$sql=rtrim(file_get_contents('sql/dc_order_emails_parents.sql'));
		$sql=stritr($sql,$p);
		$pr = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

		foreach ($pr as $k=>$v)
		{
			$subj="����������� ������������ ��� ������� � �����������-������, ".$d["dt_start_t"];
			$text="
				������������, ".$v["p_fio"].".<br>
				��� ����������� ".$v["c_fio"]." ��������� ".$d["dt_start_t"]." ��� ������� � �����������-������.<br>
				����� ���������� - ".$d["loc_name"].". <br>
				����������� - ".$d["loc_text"].". <br>
				<p>����������� - ".$d["text"]."</p>
				�� ��������� �������� - ����������� � ���������� ������������ ���������.
				";
			send_mail($v["p_mail"],$subj,$text);
			//send_mail('denis.yakovenko@avk.ua',$subj,$text);
		}

		$sql=rtrim(file_get_contents('sql/dc_order_emails_treners.sql'));
		$sql=stritr($sql,$p);
		$pr = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

		foreach ($pr as $k=>$v)
		{
			$pr1[$v['tr_fio']]['mail']=$v['tr_mail'];
			$pr1[$v['tr_fio']]['data'][$v['c_fio']]=$v['c_mail'];
		}
		if ($pr1)
		{
			foreach ($pr1 as $k=>$v)
			{
				$subj="����������� ���������� ��� ������� � �����������-������, ".$d["dt_start_t"];
				$text="<p>������������, ".$k.".</p><p>�� '�����������-�����' ����������:<br>";
				foreach($v['data'] as $k1=>$v1)
				{
					$text.=$k1."<br>";
				}
				$text.="</p><p>����� ���������� - ".$d["loc_name"].".</p>";
				$text.="<p>����������� - ".$d["loc_text"]."</p>";
				$text.="<p>����������� - ".$d["text"]."</p>";
				send_mail($v["mail"],$subj,$text);
				//send_mail('denis.yakovenko@avk.ua',$subj,$text);
			}
		}
	}
	else
	{
		echo "<h3 style='color:red'>�� ��������� ���� ���������� �����������-������ �� ��������� ������� ����������</h3>";
	}
}

$sql=rtrim(file_get_contents('sql/dc_loc.sql'));
$sql=stritr($sql,$p);
$dc_loc = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dc_loc', $dc_loc);

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

	$sql=rtrim(file_get_contents('sql/dc_order_users.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$tru = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('tru', $tru);

	$sql = rtrim(file_get_contents('sql/dc_order_users_add.sql'));
	$sql=stritr($sql,$p);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('trua', $data);

	$sql = rtrim(file_get_contents('sql/dc_order_users_add_1.sql'));
	$sql=stritr($sql,$p);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('trub', $data);

}

$smarty->display('dc_order.html');

?>