<?

//ses_req();

audit("открыл akr_total_report","akr");

InitRequestVar('tz',0);
InitRequestVar('diviz',0);
InitRequestVar('city',0);
InitRequestVar('nets',0);
InitRequestVar('akr_contr_avk',0);
InitRequestVar('akr_contr_ag',0);
InitRequestVar('sdt',$now);
InitRequestVar('edt',$now);


$p = array(":tn" => $tn);

$sql=rtrim(file_get_contents('sql/akr_total_report_filter_tz.sql'));
$sql=stritr($sql,$p);
$akr_tz = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('akr_tz', $akr_tz);

$sql=rtrim(file_get_contents('sql/akr_city.sql'));
$sql=stritr($sql,$p);
$akr_city = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('akr_city', $akr_city);

$sql=rtrim(file_get_contents('sql/akr_diviz.sql'));
$sql=stritr($sql,$p);
$akr_diviz = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('akr_diviz', $akr_diviz);

$sql=rtrim(file_get_contents('sql/akr_total_report_nets.sql'));
$sql=stritr($sql,$p);
$akr_nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('akr_nets', $akr_nets);

$sql=rtrim(file_get_contents('sql/akr_total_report_contr_avk.sql'));
$sql=stritr($sql,$p);
$akr_contr_avk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('akr_contr_avk', $akr_contr_avk);

$sql=rtrim(file_get_contents('sql/akr_total_report_contr_ag.sql'));
$sql=stritr($sql,$p);
$akr_contr_ag = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('akr_contr_ag', $akr_contr_ag);

if (isset($_REQUEST["generate"]))
{
	$p = array(
		":tn" => $tn,
		":tz_id" => $_REQUEST['tz'],
		":diviz" => $_REQUEST['diviz'],
		":city" => $_REQUEST['city'],
		":nets" => $_REQUEST['nets'],
		":akr_contr_avk" => $_REQUEST['akr_contr_avk'],
		":akr_contr_ag" => $_REQUEST['akr_contr_ag'],
		":login" => "'".$login."'",
		':sdt'=>"'".$_REQUEST['sdt']."'",
		':edt'=>"'".$_REQUEST['edt']."'"
		);

	$sql=rtrim(file_get_contents('sql/akr_total_report_itogi.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$itogi = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	//print_r($itogi);
	$smarty->assign('akr_itogi', $itogi);

	$sql=rtrim(file_get_contents('sql/akr_total_report_tz.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$z = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	//print_r($z);
	$smarty->assign('akr_head', $z);

	foreach ($z as $k=>$v)
	{
		$sql=rtrim(file_get_contents('sql/akr_total_report_dt.sql'));
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
				$sql=rtrim(file_get_contents('sql/akr_total_report_params.sql'));
				$p = array(":id" => $v1['avk_id']);
				$sql=stritr($sql,$p);
				//echo $sql;
				$z2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
				//print_r($z2);
				$z[$k]['detail'][$k1]['params']=$z2;
			}

			$sql=rtrim(file_get_contents('sql/akr_total_report_files_avk.sql'));
			$p = array(":tz_id" => $v['id'],':dt'=>"'".$v1['dt']."'");
			$sql=stritr($sql,$p);
			$z3 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$z[$k]['detail'][$k1]['files_avk']=$z3;

			$sql=rtrim(file_get_contents('sql/akr_total_report_files_ag.sql'));
			$p = array(":tz_id" => $v['id'],':dt'=>"'".$v1['dt']."'");
			$sql=stritr($sql,$p);
			$z3 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$z[$k]['detail'][$k1]['files_ag']=$z3;
		}

	}
	$smarty->assign('akr_head', $z);
}

$smarty->display('akr_total_report.html');

?>