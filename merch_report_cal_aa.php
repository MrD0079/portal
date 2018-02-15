<?
//ses_req();
if (isset($_REQUEST['save_item']))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	if (
                $_REQUEST['dts']!=''
                &&
                $_REQUEST['dte']!=''
                &&
                $_REQUEST['ag_id']!=''
                &&
                $_REQUEST['id_net']!=''
            )
	{
            $id = get_new_id();
      		$keys = array('id'=>$id);
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
		$keys = array('head_id'=>$id);
		Table_Update('merch_report_cal_aa_o', $keys,null);
		$obl = explode(',',$_REQUEST["obl"]);
		foreach ($obl as $k=>$v)
		{
			$keys = array('head_id'=>$id,'h_o'=>$v);
			Table_Update('merch_report_cal_aa_o', $keys,$keys);
		}
                echo 'Добавлена активность №'.$id;
        } else {
                echo 'Активность не добавлена, введите даты начала/окончания, сеть, заказчика';
        }
}
else
if (isset($_REQUEST['update_item']))
{
      		$keys = array('id'=>$_REQUEST["id"]);
		$vals = array($_REQUEST["field"]=>OraDate2MDBDate($_REQUEST['val']));
		Table_Update('merch_report_cal_aa_h', $keys,$vals);
}
else
if (isset($_REQUEST['get_form']))
{
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