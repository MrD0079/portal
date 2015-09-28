<?php
if (isset($_REQUEST["save"]))
{
	audit("сохранил «/п за мес€ц","mr_zp");
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('id'=>$_REQUEST['id']);
	$vals = array($_REQUEST['field']=>$_REQUEST['val'],'pin_lu_fio'=>$fio);
	Table_Update('mr_zp', $keys,$vals);
}
else
if (isset($_REQUEST["savem"]))
{
	audit("сохранил «/п за мес€ц","mr_zp");
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('dt'=>OraDate2MDBDate($_REQUEST['dt']));
	$vals = array($_REQUEST['field']=>$_REQUEST['val'],$_REQUEST['field'].'_lu_fio'=>$fio);
	Table_Update('mr_zpm', $keys,$vals);
	//print_r($keys);
	//print_r($vals);
}
else
{
audit("открыл «/п за мес€ц","mr_zp");
InitRequestVar("flt_sum",0);
InitRequestVar("flt_pin",0);
InitRequestVar("select_route_numb",0);
InitRequestVar("svms_list",0);
$p=array(
	":month_list"=>"'".$_REQUEST["month_list"]."'",
	":select_route_numb"=>$_REQUEST["select_route_numb"],
	":svms_list"=>$_REQUEST["svms_list"],
	":flt_sum"=>$_REQUEST["flt_sum"],
	":flt_pin"=>$_REQUEST["flt_pin"],
);
$sql = rtrim(file_get_contents('sql/mr_zp.sql'));
$sql=stritr($sql,$p);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('zp', $d);
$sql = rtrim(file_get_contents('sql/mr_zpt.sql'));
$sql=stritr($sql,$p);
$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('zpt', $d);
$sql = rtrim(file_get_contents('sql/mr_zpm.sql'));
$p=array(":month_list"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('h', $d);
$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);
$sql=rtrim(file_get_contents('sql/svms_list.sql'));
$p = array(":tn"=>$tn,':dpt_id'=>$_SESSION['dpt_id']);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('svms_list', $data);
$sql = rtrim(file_get_contents('sql/report_total_new_routes_head.sql'));
$p=array(":tn"=>$tn,":sd"=>"'".$_REQUEST["month_list"]."'",":ed"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head', $res);
$smarty->display('mr_zp.html');
}
?>