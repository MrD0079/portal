<?

audit("открыл azl_ag_report","azl");

InitRequestVar('tz',0);
InitRequestVar('dt',$now);

//ses_req();

$sql="select * from azl_contr_ag where login='".$login."'";

$r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

$azl_super=$r['is_super'];
$smarty->assign('azl_super', $azl_super);

if (!$r)
{
	echo '<p style="color:red; font-size:20px">Вы не являетесь контролером от АВК в данной акции</p>';
}
else
{
	$sql=rtrim(file_get_contents('sql/azl_ag_report_tz.sql'));
	$p = array(":id" => $r['id']);
	$sql=stritr($sql,$p);
	//echo $sql;
	$azl_tz = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('azl_tz', $azl_tz);

	if ($_REQUEST['tz']!=0)
	{
		if (isset($_REQUEST['save']))
		{
			$keys = array('tz_id'=>$_REQUEST['tz'],'dt'=>OraDate2MDBDate($_REQUEST['dt']));
			$vals = $_REQUEST['head'];
			Table_Update('azl_tz_ag_report',$keys,$vals);
		}
		
		$sql=rtrim(file_get_contents('sql/azl_ag_report_get_tz.sql'));
		$p = array(":id" => $_REQUEST['tz']);
		$sql=stritr($sql,$p);
		//echo $sql;
		$azl_get_tz = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		//print_r($azl_get_tz);
		$smarty->assign('azl_get_tz', $azl_get_tz);




		$sql=rtrim(file_get_contents('sql/azl_tz_files.sql'));
		$p = array(":tz_id" => $_REQUEST['tz']);
		$sql=stritr($sql,$p);
		$z3 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('tz_files', $z3);

        
		$sql=rtrim(file_get_contents('sql/azl_ag_report_head.sql'));
		$p = array(":tz_id" => $_REQUEST['tz'],':dt'=>"'".$_REQUEST['dt']."'");
		$sql=stritr($sql,$p);
		//echo $sql;
		$z = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		//print_r($z);
		$smarty->assign('azl_head', $z);
        
		$sql=rtrim(file_get_contents('sql/azl_ag_report_files.sql'));
		$p = array(":tz_id" => $_REQUEST['tz'],':dt'=>"'".$_REQUEST['dt']."'");
		$sql=stritr($sql,$p);




//echo $sql;



		$z = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);


//print_r($z);


		$smarty->assign('azl_files', $z);
	}

	$smarty->assign('id', $r['id']);
	$smarty->display('azl_ag_report.html');
}

?>