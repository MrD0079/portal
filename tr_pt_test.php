<?

//audit ("����� ������������ �� ��������","tr");

//ses_req();

if (isset($_REQUEST["test_end"]))
{
	audit ("�������� ������������ �� ��������","tr");
	$ball = 0;
	if (isset($_REQUEST["answer"]))
	{
		foreach ($_REQUEST["answer"] as $k=>$v)
		{
			$p = array();
			$p[':q'] = $k;
			$p[':a'] = join(',',array_keys($v));
			$sql=rtrim(file_get_contents('sql/tr_pt_test_process_get_q_res.sql'));
			$sql=stritr($sql,$p);
			$r = $db->getOne($sql);
			$r==1 ? $ball++ : null;
			$keys=array(
				'head'=>$_REQUEST["head"],
				'h_eta'=>$_SESSION["h_eta"],
				'q'=>$k,
				);
			$vals=array(
				'ok'=>$r
				);
			Table_Update('tr_pt_order_test_res',$keys,$vals);
		}
	}
	$smarty->assign('ball',$ball);

	$p = array();
	$p[':id'] = $_REQUEST["head"];
	$sql=rtrim(file_get_contents('sql/tr_pt_test_process_get_q_cnt.sql'));
	$sql=stritr($sql,$p);
	$ball_max = $db->getOne($sql);
	$smarty->assign('ball_max',$ball_max);

	$keys=array(
		'head'=>$_REQUEST["head"],
		'h_eta'=>$_SESSION["h_eta"]
		);
	$vals=array(
		'test_ball'=>$ball
		);
	Table_Update('tr_pt_order_body',$keys,$vals);

	$res_perc=round($ball/$ball_max*100,0);

	if ($res_perc>=85)
	{
		$res_type='�������';
	}
	else if ($res_perc<75)
	{
		$res_type='��������������������';
		$low_warning = 1;
		$smarty->assign('low_warning',1);
	}
	else
	{
		$res_type='�������';
	}
	
	$smarty->assign('res_type',$res_type);

	$sql=rtrim(file_get_contents('sql/tr_pt_list_order.sql'));
	$sql=stritr($sql,$p);
	$h = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

	$parent_email=$db->getOne("SELECT e_mail FROM user_list WHERE tn = (SELECT chief_tn FROM parents_eta WHERE h_eta = '".$_SESSION["h_eta"]."')");

	/* ������� ������������ ����������, ���������� ������������, ������������ ���������:*/
	$subj='���������� ������������ '.$fio.' �� �������� '.$h["name"];
	$text='
	������������.<br />
	������ ��� ��� ����������� ��������� '.$fio.' ������ ������������ �� �������� '.$h["name"].'.
	���� ���������� �������� - '.$h["dt_start_t"].'.
	<br/>
	<br/>
	��������� ������ <b>'.$ball.' �����(-��)</b> �� '.$ball_max.' ���������.
	<br/>
	<br/>
	������ ��������� �������� '.$res_type.'.<br>';
	if (isset($low_warning))
	{
		$text.="���������� � ��������� ����� ����� ��������� ��������� ����������� ������������.";
	}
	send_mail($parent_email,$subj,$text);
}

$p = array();
$p[':h_eta'] = "'".$_SESSION["h_eta"]."'";

$sql=rtrim(file_get_contents('sql/tr_pt_os_get_tr.sql'));
$sql=stritr($sql,$p);
$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

if ($d)
{
	$id=$d["id"];
	$p[':id'] = $id;
	$smarty->assign('d', $d);
	$sql=rtrim(file_get_contents('sql/tr_pt_list_order.sql'));
	$sql=stritr($sql,$p);
	$h = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('h', $h);

	$sql=rtrim(file_get_contents('sql/tr_pt_test_process.sql'));
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

	foreach ($res as $k=>$v)
	{
		if ($v['parent']=='')
		{
			$qa[$v['id_num']]['head']=$v;
		}
		else
		{
			$qa[$v['parent']]['data'][$v['id_num']]=$v;
		}
	}
	$smarty->assign('qa', $qa);

	if (isset($_REQUEST["process"]))
	{
		audit ("����� ������������ �� ��������","tr");
		$keys=array(
			'head'=>$id,
			'h_eta'=>$_SESSION["h_eta"]
			);
		$vals=array(
			'test'=>2
			);
		Table_Update('tr_pt_order_body',$keys,$vals);
	}

}

$smarty->display('tr_pt_test.html');

?>