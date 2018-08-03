<?

$params=array(':z_id'=>$_REQUEST["z_id"]);

$sql=rtrim(file_get_contents('sql/akcii_local_report.sql'));
$sql=stritr($sql,$params);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign("act_head", $data);
/*
$_REQUEST['z']=$data;
$_REQUEST['z1']=$sql;

*/

$sql=rtrim(file_get_contents('sql/akcii_local_report_z_head.sql'));
$sql=stritr($sql,$params);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign("z_head", $data);

$sql=rtrim(file_get_contents('sql/bud_ru_zay_get_ff.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($data as $k1=>$v1)
{
	if ($v1["type"]=="file")
	{
		$data[$k1]["val_file"]=explode("\n",$v1["val_file"]);
	}
	/*if ($v1['type']=='list')
	{
		if ($v1['val_list'])
		{
		$sql=$db->getOne('SELECT get_item FROM bud_ru_ff_subtypes WHERE id = (SELECT subtype FROM bud_ru_ff WHERE id = '.$v1['ff_id'].')');
		$params[':id'] = $v1['val_list'];
		$sql=stritr($sql,$params);
		$list = $db->getOne($sql);
		$data[$k1]['val_list_name'] = $list;
		}
	}*/
}
$smarty->assign("z_ff", $data);

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("ok_selected",1);

$params=array(
	':z_id' => $_REQUEST["z_id"],
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
	':ok_selected' => $_REQUEST["ok_selected"],
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_only_ts', $exp_list_only_ts);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

$sql = rtrim(file_get_contents('sql/akcii_local_report_eta_list.sql'));
$sql=stritr($sql,$params);
$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('eta_list', $eta_list);

$period=$db->getOne("SELECT c.mt || ' ' || c.y FROM calendar c, bud_ru_zay z WHERE z.id = ".$_REQUEST["z_id"]." AND TRUNC (z.dt_start, 'mm') = c.data");
$smarty->assign('period', $period);

if (isset($_REQUEST['generate']))
{

$sql = rtrim(file_get_contents('sql/akcii_local_report_sales.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('sales', $x);
/*
$_REQUEST['z']=$x;
$_REQUEST['z1']=$sql;

*/


$sql = rtrim(file_get_contents('sql/akcii_local_report_sales_total.sql'));
$sql=stritr($sql,$params);
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('total', $x);

$sql = rtrim(file_get_contents('sql/akcii_local_report_files.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('f', $x);

}

$smarty->display('akcii_local_report.html');

?>