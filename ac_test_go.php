<?

//audit ("начал тестирование по тренингу","tr");

//ses_req();

$p = array();
$p[':ac_id'] = $_REQUEST["ac_id"];
$p[':memb_id'] = $_REQUEST["memb_id"];
$p[':ac_test_id'] = $_REQUEST["ac_test_id"];


$sql=rtrim(file_get_contents('sql/ac_test_get_memb_table.sql'));
$sql=stritr($sql,$p);
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$memb_table = $x["table_name"];
$test_type = $x["test_type"];



if (isset($_REQUEST["test_end"]))
{
	audit ("закончил тестирование по тренингу","tr");
	$ball = 0;
	if (isset($_REQUEST["answer"]))
	{
		foreach ($_REQUEST["answer"] as $k=>$v)
		{
			$p = array();
			$p[':q'] = $k;
			$p[':a'] = join(',',array_keys($v));
			$sql=rtrim(file_get_contents('sql/ac_test_go_process_get_q_res.sql'));
			$sql=stritr($sql,$p);
			$r = $db->getOne($sql);
			$r==1 ? $ball++ : null;
			$keys=array(
				'ac_id'=>$_REQUEST["ac_id"],
				'memb_id'=>$_REQUEST["memb_id"],
				'test_id'=>$_REQUEST["ac_test_id"],
				'q'=>$k,
				);
			$vals=array(
				'ok'=>$r
				);
			Table_Update('ac_test_res',$keys,$vals);
		}
	}
	$smarty->assign('ball',$ball);

	$p = array();
	$p[':ac_test_id'] = $_REQUEST["ac_test_id"];
	$sql=rtrim(file_get_contents('sql/ac_test_go_process_get_q_cnt.sql'));
	$sql=stritr($sql,$p);
	$ball_max = $db->getOne($sql);
	$smarty->assign('ball_max',$ball_max);

	$keys=array(
		'id'=>$_REQUEST["memb_id"],
		);
	$vals=array(
		$test_type.'_test_ball'=>$ball
		);
	Table_Update($memb_table,$keys,$vals);

	$res_perc=round($ball/$ball_max*100,0);

	if ($res_perc>=75)
	{
		$res_type='высоким';
	}
	else if ($res_perc<50)
	{
		$res_type='неудовлетворительным';
		$low_warning = 1;
		$smarty->assign('low_warning',1);
	}
	else
	{
		$res_type='средним';
	}
	
	$smarty->assign('res_type',$res_type);

	/*$sql=rtrim(file_get_contents('sql/ac_test_go_order.sql'));
	$sql=stritr($sql,$p);
	$h = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);*/

	//$parent_email=$db->getOne('select e_mail from user_list where tn=(select parent from parents where tn='.$tn.')');

	/* Прямому руководителю сотрудника, прошедшему тестирование, отправляется сообщение:*/
	/*
	$subj='Результаты тестирования '.$fio.' по тренингу '.$h["name"];
	$text='
	Здравствуйте.<br />
	Только что Ваш подчиненный сотрудник '.$fio.' прошел тестирование по тренингу '.$h["name"].'.
	Дата проведения тренинга - '.$h["dt_start_t"].'.
	<br/>
	<br/>
	Сотрудник набрал <b>'.$ball.' балла(-ов)</b> из '.$ball_max.' возможных.
	<br/>
	<br/>
	Данный результат является '.$res_type.'.<br>';
	if (isset($low_warning))
	{
		$text.="Сотруднику в ближайшее время будет назначено повторное прохождение тестирования.";
	}
	send_mail($parent_email,$subj,$text);
	*/
}


$p = array();
$p[':ac_id'] = $_REQUEST["ac_id"];
$p[':memb_id'] = $_REQUEST["memb_id"];
$p[':ac_test_id'] = $_REQUEST["ac_test_id"];

$sql=rtrim(file_get_contents('sql/ac_test_go_test_list.sql'));
$sql=stritr($sql,$p);
$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

//echo $sql;
//print_r($d);

if ($d)
{
	//$id=$d["id"];
	//$p[':id'] = $id;
	$smarty->assign('d', $d);
	/*$sql=rtrim(file_get_contents('sql/tr_list_order.sql'));
	$sql=stritr($sql,$p);
	$h = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('h', $h);*/

	$sql=rtrim(file_get_contents('sql/ac_test_go_process.sql'));
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

	foreach ($res as $k=>$v)
	{
		if ($v['parent']==$_REQUEST["ac_test_id"])
		{
			$qa[$v['id']]['head']=$v;
		}
		else
		{
			$qa[$v['parent']]['data'][$v['id']]=$v;
		}
	}
	$smarty->assign('qa', $qa);

	if (isset($_REQUEST["process"]))
	{
		audit ("начал тестирование по АЦ","ac");
		$keys=array(
			'id'=>$_REQUEST["memb_id"],
			);
		$vals=array(
			$test_type.'_test'=>2
			);
		Table_Update($memb_table,$keys,$vals);
	}
}

$smarty->display('ac_test_go.html');

?>