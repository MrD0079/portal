<?
if (isset($_REQUEST['add_item']))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	ses_req();
	if ($_REQUEST['id']!='undefined'&&$_REQUEST['dts']!=''&&$_REQUEST['dte']!='')
	{
      		$keys = array('id'=>$_REQUEST["id"]);
		$vals = array(
			'dts'=>OraDate2MDBDate($_REQUEST['dts']),
			'dte'=>OraDate2MDBDate($_REQUEST['dte']),
			'ag_id'=>$_REQUEST['ag_id'],
			'h_city'=>$_REQUEST['h_city'],
			'id_net'=>$_REQUEST['id_net'],
			'text'=>$_REQUEST['text'],
			'tasks'=>$_REQUEST['tasks']
		);
		Table_Update('merch_report_cal_aa_h', $keys,$vals);
		$keys = array('head_id'=>$_REQUEST["id"]);
		Table_Update('merch_report_cal_aa_o', $keys,null);
		$obl = split(',',$_REQUEST["obl"]);
		foreach ($obl as $k=>$v)
		{
			$keys = array('head_id'=>$_REQUEST["id"],'h_o'=>$v);
			Table_Update('merch_report_cal_aa_o', $keys,$keys);
		}
                $smarty->assign('result', 'Добавлена активность №'.$_REQUEST["id"]);
        } else {
                $smarty->assign('result', 'Активность не добавлена, введите даты начала/окончания');
        }
	$smarty->assign('id', get_new_id());
	$sql = rtrim(file_get_contents('sql/merch_report_cal_aa_list_a.sql'));
	$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('agents', $x);
	$sql = rtrim(file_get_contents('sql/merch_report_cal_aa_list_o.sql'));
	$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('obl', $x);
	$sql = rtrim(file_get_contents('sql/merch_report_cal_aa_list_n.sql'));
	$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('nets', $x);
	$sql = rtrim(file_get_contents('sql/merch_report_cal_aa_list_c.sql'));
	$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('cities', $x);
	$smarty->display('merch_report_cal_aa_add_item.html');
}
else
if (isset($_REQUEST['del_item']))
{
	Table_Update('merch_report_cal_aa_h', array('id'=>$_REQUEST["id"]),null);
}
else
if (isset($_REQUEST['get_list']))
{
	$sql = rtrim(file_get_contents('sql/merch_report_cal_aa_get_list.sql'));
	$p=array(
		':ag_id'=>$_REQUEST['list_ag_id'],
		':dt'=>$_REQUEST['list_dt'],
	);
	$sql=stritr($sql,$p);
	$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('tbl', $x);
	$smarty->display('merch_report_cal_aa_get_list.html');
}
else
{
	$sql = rtrim(file_get_contents('sql/merch_report_cal_aa_list_a.sql'));
	$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('agents', $x);
	$smarty->display('merch_report_cal_aa.html');
}
?>