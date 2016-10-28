<?
//audit ("начал тестирование по тренингу","tr");
//ses_req();
if (isset($_REQUEST["test_end"]))
{
	$p = array();
	$p[':tn'] = $tn;
	$sql=rtrim(file_get_contents('sql/prob_test_go_test_list.sql'));
	$sql=stritr($sql,$p);
	$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	audit ("закончил тестирование по АП","prob");
	$ball = 0;
	Table_Update('prob_test_res',array('tn'=>$tn,'test_id'=>$d["test_id"]),null);
	if (isset($_REQUEST["answer"]))
	{
		foreach ($_REQUEST["answer"] as $k=>$v)
		{
			$p[':q'] = $k;
			$p[':a'] = join(',',array_keys($v));
			$sql=rtrim(file_get_contents('sql/prob_test_go_process_get_q_res.sql'));
			$sql=stritr($sql,$p);
			$r = $db->getOne($sql);
			$r==1 ? $ball++ : null;
			Table_Update('prob_test_res',array('tn'=>$tn,'test_id'=>$d["test_id"],'q'=>$k),array('ok'=>$r));
		}
	}
	$smarty->assign('ball',$ball);
	$sql=rtrim(file_get_contents('sql/prob_test_go_process_get_q_cnt.sql'));
	$sql=stritr($sql,$p);
	$ball_max = $db->getOne($sql);
	$smarty->assign('ball_max',$ball_max);
	Table_Update("p_plan",array('tn'=>$tn),array('test_ball'=>$ball));
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
	$parent_email=$db->getOne('select e_mail from user_list where tn=(select parent from parents where tn='.$tn.')');
	/* Прямому руководителю сотрудника, прошедшему тестирование, отправляется сообщение:*/
	$subj='Результаты тестирования '.$fio.' по тренингу '.$d["name"];
	$text='
	Здравствуйте.<br>
	Только что Ваш подчиненный сотрудник '.$fio.' прошел тестирование по результатам прохождения адаптационной программы '.$d["name"].'.<br>
	Сотрудник набрал <b>'.$ball.' балла(-ов)</b> из '.$ball_max.' возможных.<br>
	Данный результат является '.$res_type.'.<br>';
	if (isset($low_warning))
	{
		$text.="Сотруднику в ближайшее время будет назначено повторное прохождение тестирования.";
	}
	send_mail($parent_email,$subj,$text);
}

$p = array();
$p[':tn'] = $tn;
$sql=rtrim(file_get_contents('sql/main_prob_test.sql'));
$sql=stritr($sql,$p);
$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

if ($d)
{
	$smarty->assign('d', $d);
	$sql=rtrim(file_get_contents('sql/prob_test_go_process.sql'));
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($res as $k=>$v)
	{
		($v['parent']==$d["test_id"])?$qa[$v['id']]['head']=$v:$qa[$v['parent']]['data'][$v['id']]=$v;
	}
	$smarty->assign('qa', $qa);
	if (isset($_REQUEST["process"]))
	{
		audit ("начал тестирование по АП","prob");
		Table_Update("p_plan",array('tn'=>$tn),array('test'=>2));
		//echo "Table_Update('p_plan',array('tn'=>$tn),array('test'=>2))";
	}
}
$smarty->display('prob_test_go.html');
?>