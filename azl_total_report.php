<?

//ses_req();

audit("открыл azl_total_report","azl");

InitRequestVar('tz',0);
InitRequestVar('diviz',0);
InitRequestVar('city',0);
InitRequestVar('nets',0);
InitRequestVar('azl_contr_avk',0);
InitRequestVar('azl_contr_ag',0);
InitRequestVar('sdt',$now);
InitRequestVar('edt',$now);


$p = array(":tn" => $tn);

$sql=rtrim(file_get_contents('sql/azl_total_report_filter_tz.sql'));
$sql=stritr($sql,$p);
$azl_tz = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('azl_tz', $azl_tz);

$sql=rtrim(file_get_contents('sql/azl_city.sql'));
$sql=stritr($sql,$p);
$azl_city = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('azl_city', $azl_city);

$sql=rtrim(file_get_contents('sql/azl_diviz.sql'));
$sql=stritr($sql,$p);
$azl_diviz = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('azl_diviz', $azl_diviz);

$sql=rtrim(file_get_contents('sql/azl_total_report_nets.sql'));
$sql=stritr($sql,$p);
$azl_nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('azl_nets', $azl_nets);

$sql=rtrim(file_get_contents('sql/azl_total_report_contr_avk.sql'));
$sql=stritr($sql,$p);
$azl_contr_avk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('azl_contr_avk', $azl_contr_avk);

$sql=rtrim(file_get_contents('sql/azl_total_report_contr_ag.sql'));
$sql=stritr($sql,$p);
$azl_contr_ag = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('azl_contr_ag', $azl_contr_ag);

if (isset($_REQUEST["generate"]))
{
	$p = array(
		":tn" => $tn,
		":tz_id" => $_REQUEST['tz'],
		":diviz" => $_REQUEST['diviz'],
		":city" => $_REQUEST['city'],
		":nets" => $_REQUEST['nets'],
		":azl_contr_avk" => $_REQUEST['azl_contr_avk'],
		":azl_contr_ag" => $_REQUEST['azl_contr_ag'],
		":login" => "'".$login."'",
		':sdt'=>"'".$_REQUEST['sdt']."'",
		':edt'=>"'".$_REQUEST['edt']."'"
		);

	$sql=rtrim(file_get_contents('sql/azl_total_report_itogi.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$itogi = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	//print_r($itogi);
	$smarty->assign('azl_itogi', $itogi);

	$sql=rtrim(file_get_contents('sql/azl_total_report_tz.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$z = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	//print_r($z);
	$smarty->assign('azl_head', $z);

	foreach ($z as $k=>$v)
	{
		$sql=rtrim(file_get_contents('sql/azl_total_report_dt.sql'));
		$p = array(
			":tz_id" => $v['id'],
			':sdt'=>"'".$_REQUEST['sdt']."'",
			':edt'=>"'".$_REQUEST['edt']."'"
			);
		$sql=stritr($sql,$p);
		//echo $sql."<br>";
		$z1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		//print_r($z1);
		$z[$k]['detail']=$z1;

		foreach ($z1 as $k1=>$v1)
		{
			if ($v1['avk_id'])
			{
				$sql=rtrim(file_get_contents('sql/azl_total_report_params.sql'));
				$p = array(":id" => $v1['avk_id']);
				$sql=stritr($sql,$p);
				//echo $sql;
				$z2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
				//print_r($z2);
				$z[$k]['detail'][$k1]['params']=$z2;
			}

			$sql=rtrim(file_get_contents('sql/azl_total_report_files_avk.sql'));
			$p = array(":tz_id" => $v['id'],':dt'=>"'".$v1['dt']."'");
			$sql=stritr($sql,$p);
			$z3 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$z[$k]['detail'][$k1]['files_avk']=$z3;

			$sql=rtrim(file_get_contents('sql/azl_total_report_files_ag.sql'));
			$p = array(":tz_id" => $v['id'],':dt'=>"'".$v1['dt']."'");
			$sql=stritr($sql,$p);
			$z3 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$z[$k]['detail'][$k1]['files_ag']=$z3;
		}

	}
	$smarty->assign('azl_head', $z);
}

$smarty->display('azl_total_report.html');

?>