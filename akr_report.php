<?

audit("открыл akr_report","akr");

InitRequestVar('tz',0);
InitRequestVar('dt',$now);

//ses_req();

$sql="select * from akr_contr_avk where '".$login."' IN (login, to_char(inn))";

$r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

$akr_super=$r['is_super'];
$smarty->assign('akr_super', $akr_super);

if (!$r)
{
	echo '<p style="color:red; font-size:20px">Вы не являетесь контролером от АВК в данной акции</p>';
}
else
{
	$sql=rtrim(file_get_contents('sql/akr_balls.sql'));
	$balls = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('balls', $balls);

	$sql=rtrim(file_get_contents('sql/akr_report_tz.sql'));
	$p = array(":id" => $r['id']);
	$sql=stritr($sql,$p);
	$akr_tz = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('akr_tz', $akr_tz);

	if ($_REQUEST['tz']!=0)
	{
		if (isset($_REQUEST['save']))
		{
			$keys = array('tz_id'=>$_REQUEST['tz'],'dt'=>OraDate2MDBDate($_REQUEST['dt']));
			$vals = $_REQUEST['head'];
			Table_Update('akr_tz_report',$keys,$vals);
		}
		
		$sql=rtrim(file_get_contents('sql/akr_report_get_tz.sql'));
		$p = array(":id" => $_REQUEST['tz']);
		$sql=stritr($sql,$p);
		//echo $sql;
		$akr_get_tz = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		//print_r($akr_get_tz);
		$smarty->assign('akr_get_tz', $akr_get_tz);




		$sql=rtrim(file_get_contents('sql/akr_tz_files.sql'));
		$p = array(":tz_id" => $_REQUEST['tz']);
		$sql=stritr($sql,$p);
		$z3 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('tz_files', $z3);




        
		$sql=rtrim(file_get_contents('sql/akr_report_head.sql'));
		$p = array(":tz_id" => $_REQUEST['tz'],':dt'=>"'".$_REQUEST['dt']."'");
		$sql=stritr($sql,$p);
		//echo $sql;
		$z = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		//print_r($z);
		$smarty->assign('akr_head', $z);
        
		$rep_id = 0;
		if (isset($z['id']))
		{
			if (isset($_REQUEST['save']))
			{
				//echo $z['id'];
				foreach ($_REQUEST['detail'] as $k=>$v)
				{
					$keys = array('rep_id'=>$z['id'],'prm_id'=>$k);
					$vals = array('val'=>$v);
					Table_Update('akr_tz_report_params',$keys,$vals);
				}
			}
			$rep_id = $z['id'];
        
		}
        
		$sql=rtrim(file_get_contents('sql/akr_report_detail.sql'));
		$p = array(":id" => $rep_id);
		$sql=stritr($sql,$p);
		//echo $sql;
		$z1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		//print_r($z1);
		$smarty->assign('akr_detail', $z1);



		$sql=rtrim(file_get_contents('sql/akr_report_files.sql'));
		$p = array(":tz_id" => $_REQUEST['tz'],':dt'=>"'".$_REQUEST['dt']."'");
		$sql=stritr($sql,$p);
		$z = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('akr_files', $z);






	}

	$smarty->assign('id', $r['id']);
	$smarty->display('akr_report.html');
}

?>