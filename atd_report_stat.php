<?

audit("открыл atd_report_stat","atd");

InitRequestVar('tz',0);
InitRequestVar('diviz',0);
InitRequestVar('city',0);
InitRequestVar('nets',0);
InitRequestVar('sdt',$now);
InitRequestVar('edt',$now);

//ses_req();

$sql="select * from atd_contr_avk where '".$login."' IN (login, to_char(inn))";

$r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

$atd_super=$r['is_super'];
$smarty->assign('atd_super', $atd_super);

if (!$r)
{
	echo '<p style="color:red; font-size:20px">Вы не являетесь контролером от АВК в данной акции</p>';
}
else
{
	$sql=rtrim(file_get_contents('sql/atd_balls.sql'));
	$balls = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('balls', $balls);

	$sql=rtrim(file_get_contents('sql/atd_report_stat_tz.sql'));
	$p = array(":id" => $r['id']);
	$sql=stritr($sql,$p);
	$atd_tz = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('atd_tz', $atd_tz);

	$sql=rtrim(file_get_contents('sql/atd_report_stat_head.sql'));
	$p = array(
		":tz_id" => $_REQUEST['tz'],
		":diviz" => $_REQUEST['diviz'],
		":city" => $_REQUEST['city'],
		":nets" => $_REQUEST['nets'],
		":login" => "'".$login."'",
		':sdt'=>"'".$_REQUEST['sdt']."'",
		':edt'=>"'".$_REQUEST['edt']."'"
		);
	$sql=stritr($sql,$p);
	//echo $sql;
	$z = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	//print_r($z);
	$smarty->assign('atd_head', $z);

	foreach ($z as $k=>$v)
	{
		$sql=rtrim(file_get_contents('sql/atd_report_stat_detail.sql'));
		$p = array(
			":tz_id" => $v['id'],
			':sdt'=>"'".$_REQUEST['sdt']."'",
			':edt'=>"'".$_REQUEST['edt']."'"
			);
		$sql=stritr($sql,$p);
		//echo $sql;
		$z1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		//print_r($z1);
		$z[$k]['detail']=$z1;

		foreach ($z1 as $k1=>$v1)
		{
			$sql=rtrim(file_get_contents('sql/atd_report_stat_params.sql'));
			$p = array(":id" => $v1['id']);
			$sql=stritr($sql,$p);
			//echo $sql;
			$z2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			//print_r($z1);
			$z[$k]['detail'][$k1]['params']=$z2;

			$sql=rtrim(file_get_contents('sql/atd_report_stat_files.sql'));
			$p = array(":tz_id" => $v1['tz_id'],':dt'=>"'".$v1['dt']."'");
			$sql=stritr($sql,$p);
			$z3 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$z[$k]['detail'][$k1]['files']=$z3;
		}

	}
	$smarty->assign('atd_head', $z);
	//print_r($z);

	$smarty->assign('id', $r['id']);






$sql=rtrim(file_get_contents('sql/atd_city.sql'));
$atd_city = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('atd_city', $atd_city);

$sql=rtrim(file_get_contents('sql/atd_diviz.sql'));
$atd_diviz = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('atd_diviz', $atd_diviz);

$sql=rtrim(file_get_contents('sql/atd_nets.sql'));
$atd_nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('atd_nets', $atd_nets);









	$smarty->display('atd_report_stat.html');
}

?>