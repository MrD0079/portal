<?

audit ("������ ����� ��������� ��������","tr");



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
			/* ������ ������������ �����������, ������������ �� ������� (����������), �������� �������������� ��������� �� �������:*/
	        
			$subj="�� �� ������� � �������� '".$h["name"]."' ���������� ".$v1["c_fio"];
			$text="������������, ".$v1["p_fio"].".<br /><br />
			".$h["fio"]." � �������� �������, ������������ ������ ������� ".$h["dt_start_t"].", ������� ��������� �������� ����� �� ���������: <br />
			".nl2br($v1["os"]).".";
			send_mail($v1["p_mail"],$subj,$text);
	        
			/* ���������� �������� ������������ ������ �� �������������� ������� */
	        
			$subj="����������� ������������ �� �������� '".$h["name"]."'.";
			$text="������������, ".$v1["c_fio"].". �� ���� ���������� �������� '".$h["name"]."' ".$h["dt_start_t"].".<br>
			��� ���������� ��������� �� �� ����������� �������� � ������ ��������������� ������������.<br>
			��� ����� �������� �� ������ <a href=\"https://ps.avk.ua/?action=tr_os\">������</a>, ���� ������� ����� ������������� ������ � ������ �������� / �������� / �� �� �������� �� � ������������.<br /><br />
			<h3><b>������ ����� ������� � ������� 48 ����� � ������� ��������� ������� ���������!<br />
			�������, � ��� ���� ������ ���� ������� ������ ����. ����� ������������, �� ������ ������ ��� �� �����!</b></h3>";
			send_mail($v1["c_mail"],$subj,$text);
		}


		/* ����������� �� ����������� ������ pers2 ��� ������, � ������� ��������� �������� �������� ������������ �������������� ��������� */

		$sql=rtrim(file_get_contents('sql/tr_report_pers2.sql'));
		$sql=stritr($sql,$p);
		$p2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

		foreach ($p2 as $pk=>$pv)
		{
			$p2d[$pv["e_mail"]][$pv["fio"]]=$pv["pos_name"];
		}

		$subj="�������� ������� '".$h["name"]."'.";


		if (isset($p2d))
		{
			foreach ($p2d as $pk2=>$pv2)
			{
				$text='�������� ������� '.$h["name"].'. <br />
				���� ���������� - '.$h["dt_start_t"].', ���� ��������� � '.$h["tr_end"].' <br />
				������ - '.$h["fio"].'<br />
				����� ���������� �������� - '.$h["loc_name"].'. <br />
				����������� - '.nl2br($h['text']).'<br />
				������ ����������: <br />';
				foreach ($pv2 as $pk3=>$pv3)
				{
					$text.=$pk3.' - '.$pv3.'<br />';
				}
				$text.='������� ������ ���������� � ���� ���������.';
				send_mail($pk2,$subj,$text);
			}
		}

		/* ������ ���������� ����� ����������� �� ������� accept1 � accept2 */

		$sql=rtrim(file_get_contents('sql/tr_report_accept12.sql'));
		$sql=stritr($sql,$p);
		$a2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

		foreach ($a2 as $ak=>$av)
		{
			$a2d[$av["e_mail"]][$av["fio"]]=$av["pos_name"];
		}

		$subj="�������� ������� '".$h["name"]."'.";

		if (isset($a2d))
		{
			foreach ($a2d as $ak2=>$av2)
			{
				$text='�������� ������� '.$h["name"].'. <br />������: '.$h["fio"].'. <br />����� ���������� �������� '.$h["loc_name"].'. <br />���� ���������� - '.$h["dt_start_t"].', ���� ��������� � '.$h["tr_end"].' <br />������ ����������: <br />';
				foreach ($av2 as $ak3=>$av3)
				{
					$text.=$ak3.' - '.$av3.'<br />';
				}
				$text.='������� ������ ���������� � ���� ��������� � ������ ��� �������� ��������������� ��������.';
				send_mail($ak2,$subj,$text);
			}
		}

		/* �������� ���� ���, ��� ������������� � ��� �� �������� ���� */
		Table_Update("tr_order_body",array("head" => $_REQUEST["id"],"completed" => 1,"test" => 0),array("test" => 1));
	}
}


/* ��������� ��������� ����� */

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