<?

audit("открыл merch_report_sb","merch_report_sb");

$sql = rtrim(file_get_contents('sql/merch_report_dates_list.sql'));
$dates_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dates_list', $dates_list);
InitRequestVar("dates_list",$now);
foreach ($dates_list as $k=>$v){if ($v["data_c"]==$_REQUEST["dt"]){$day=$v["dm"];}}
//echo $day;

$sql = rtrim(file_get_contents('sql/merch_report_head.sql'));
$p=array(":data"=>"'".$_REQUEST["dt"]."'",":login"=>"'".$login."'");
$sql=stritr($sql,$p);
$r=$db->GetRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('route', $r);

$sql = rtrim(file_get_contents('sql/merch_report_vp_all.sql'));
$products=$db->GetAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('products', $products);

$sql = rtrim(file_get_contents('sql/merch_report_sb_comm.sql'));
$comm=$db->GetAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('comm', $comm);

if (isset($r["id"]))
{
	if ($r["id"]!="")
	{
		$_REQUEST['id']==0?$_REQUEST['id']=get_new_id():null;
		$keys=array(
			"dt"=>OraDate2MDBDate($_REQUEST["dt"]),
			"head_id"=>$r["id"],
			"kod_tp"=>$_REQUEST["kodtp"]
		);
		Table_Update('merch_report_sb_head',$keys,$keys);
		$keys=array(
			"id"=>$_REQUEST['id'],
			"dt"=>OraDate2MDBDate($_REQUEST["dt"]),
			"head_id"=>$r["id"],
			"kod_tp"=>$_REQUEST["kodtp"]
		);
		Table_Update('merch_report_sb',$keys,$keys);
		$sql = rtrim(file_get_contents('sql/merch_report_sb_item.sql'));
		$p=array(":id"=>$_REQUEST['id']);
		$sql=stritr($sql,$p);
		$rb = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('sb_item', $rb);
		//echo $sql;
		//print_r($p);
	}
}

$smarty->display('merch_report_sb_item.html');

?>