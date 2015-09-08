<?

audit("открыл azl_report_stat","azl");

InitRequestVar('tz',0);
InitRequestVar('diviz',0);
InitRequestVar('city',0);
InitRequestVar('nets',0);
InitRequestVar('sdt',$now);
InitRequestVar('edt',$now);

//ses_req();

$sql="select * from azl_contr_avk where '".$login."' IN (login, to_char(inn))";

$r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

$azl_super=$r['is_super'];
$smarty->assign('azl_super', $azl_super);

if (!$r)
{
	echo '<p style="color:red; font-size:20px">Вы не являетесь контролером от АВК в данной акции</p>';
}
else
{
	$sql=rtrim(file_get_contents('sql/azl_balls.sql'));
	$balls = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('balls', $balls);

	$sql=rtrim(file_get_contents('sql/azl_report_stat_tz.sql'));
	$p = array(":id" => $r['id']);
	$sql=stritr($sql,$p);
	$azl_tz = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('azl_tz', $azl_tz);

	$sql=rtrim(file_get_contents('sql/azl_report_stat_head.sql'));
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
	$smarty->assign('azl_head', $z);

	foreach ($z as $k=>$v)
	{
		$sql=rtrim(file_get_contents('sql/azl_report_stat_detail.sql'));
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
			$sql=rtrim(file_get_contents('sql/azl_report_stat_params.sql'));
			$p = array(":id" => $v1['id']);
			$sql=stritr($sql,$p);
			//echo $sql;
			$z2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			//print_r($z1);
			$z[$k]['detail'][$k1]['params']=$z2;

			$sql=rtrim(file_get_contents('sql/azl_report_stat_files.sql'));
			$p = array(":tz_id" => $v1['tz_id'],':dt'=>"'".$v1['dt']."'");
			$sql=stritr($sql,$p);
			$z3 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$z[$k]['detail'][$k1]['files']=$z3;
		}

	}
	$smarty->assign('azl_head', $z);
	//print_r($z);

	$smarty->assign('id', $r['id']);






$sql=rtrim(file_get_contents('sql/azl_city.sql'));
$azl_city = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('azl_city', $azl_city);

$sql=rtrim(file_get_contents('sql/azl_diviz.sql'));
$azl_diviz = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('azl_diviz', $azl_diviz);

$sql=rtrim(file_get_contents('sql/azl_nets.sql'));
$azl_nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('azl_nets', $azl_nets);









	$smarty->display('azl_report_stat.html');
}

?>