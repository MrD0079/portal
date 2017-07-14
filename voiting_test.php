<?
//audit ("начал тестирование по тренингу","tr");
//ses_req();
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
			$sql=rtrim(file_get_contents('sql/voiting_test_process_get_q_res.sql'));
			$sql=stritr($sql,$p);
			$r = $db->getOne($sql);
			$r==1 ? $ball++ : null;
			$keys=array(
				'head'=>$_REQUEST["head"],
				'tn'=>$tn,
				'q'=>$k,
				);
			$vals=array(
				'ok'=>$r
				);
			Table_Update('voiting_order_test_res',$keys,$vals);
		}
	}
	$keys=array(
		'head'=>$_REQUEST["head"],
		'tn'=>$tn
		);
	$vals=array(
		'test_ball'=>$ball,
		'test_finished'=>date("Y-m-d H:i:s")
		);
	Table_Update('voiting_order_body',$keys,$vals);
}
else
{
	$id=$_REQUEST["id"];
	$p=array(':id'=>$id,':tn'=>$tn);
	$sql=rtrim(file_get_contents('sql/voiting_list_order.sql'));
	$sql=stritr($sql,$p);
	$h = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('h', $h);
	$sql=rtrim(file_get_contents('sql/voiting_test_process.sql'));
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
		audit ("начал тестирование по тренингу","tr");
		$keys=array(
			'tr'=>$id,
			'tn'=>$tn
			);
		Table_Update('voiting_test_onoff',$keys,null);
                
                $keys=array(
                    'head'=>$id,
                    'tn'=>$tn
		);
                $vals=array(
                        'test_started'=>date("Y-m-d H:i:s")
                        );
                Table_Update('voiting_order_body',$keys,$vals);
	}
}
$smarty->display('voiting_test.html');
?>