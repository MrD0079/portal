<?php

audit("открыл w4u_admin_pb","w4u");

InitRequestVar("mode",'auto');
InitRequestVar("eta_new",'');
InitRequestVar("eta_old",$_REQUEST["eta_new"]);





//ses_req();

if (isset($_REQUEST["save"]))
{
	if ($_REQUEST['mode']=='auto')
	{
		$keys=array(
			'm' => OraDate2MDBDate($_REQUEST['ml']),
			'h_fio_eta' => $_REQUEST["eta_old"]
		);
		$vals=array(
			'visible'=>$_REQUEST['old_visible']
		);
		//print_r($keys);
		//print_r($vals);
		Table_Update('w4u_transit',$keys,$vals);
        
		$p=array();
		$p[':dt'] = "'".$_REQUEST["ml"]."'";
		$p[':h_fio_eta_old'] = "'".$_REQUEST["eta_old"]."'";
		$p[':h_fio_eta_new'] = "'".$_REQUEST["eta_new"]."'";
		$sql = rtrim(file_get_contents('sql/w4u_admin_pb_set_data.sql'));
		$sql=stritr($sql,$p);
		//echo $sql;
		$res = $db->query($sql);
        
		$eta_old = $db->getOne("select distinct fio_eta from w4u_transit where h_fio_eta='".$_REQUEST["eta_old"]."'");
		$eta_new = $db->getOne("select distinct fio_eta from w4u_transit where h_fio_eta='".$_REQUEST["eta_new"]."'");
        
		$keys=array(
			'h_fio_eta_old' => $_REQUEST["eta_old"],
			'h_fio_eta_new' => $_REQUEST["eta_new"],
			'fio_eta_old' => $eta_old,
			'fio_eta_new' => $eta_new,
			'm' => OraDate2MDBDate($_REQUEST['ml']),
			'old_eta_visible' => $_REQUEST['old_visible'],
			'new_eta_visible' => 1,
			'id' => get_new_id()
		);
		Table_Update('w4u_pb_log',$keys,$keys);
	}
	if ($_REQUEST['mode']=='manual')
	{

		$eta_new = $db->getOne("select distinct fio_eta from w4u_transit where h_fio_eta='".$_REQUEST["eta_new"]."'");
		$ts_new = $db->getOne("select distinct fio_ts from w4u_transit where h_fio_eta='".$_REQUEST["eta_new"]."'");
		$tn_new = $db->getOne("select distinct tab_num from w4u_transit where h_fio_eta='".$_REQUEST["eta_new"]."'");
		$bm_new = $db->getOne("select distinct to_char(bm,'dd.mm.yyyy') from w4u_vp where m=TO_DATE ('".$_REQUEST['ml']."', 'dd.mm.yyyy')");

		foreach ($_REQUEST["new_qtytt"] as $k=>$v)
		{
			$keys=array(
				'm' => OraDate2MDBDate($_REQUEST['ml']),
				'h_fio_eta' => $_REQUEST["eta_new"],
				'product_id' => $k
			);
			$vals=array(
				'qtytt'=>$v,
				'fio_eta' => $eta_new,
				'fio_ts' => $ts_new,
				'tab_num' => $tn_new,
				'data' => OraDate2MDBDate($bm_new)
			);
			//print_r($keys);
			//print_r($vals);
			Table_Update('w4u_transit',$keys,$vals);
		}

		$keys=array(
			'm' => OraDate2MDBDate($_REQUEST['ml']),
			'h_fio_eta' => $_REQUEST["eta_new"]
		);
		$vals=array(
			'visible'=>$_REQUEST['new_visible'],
			'akb'=>$_REQUEST['new_akb']
		);
		//print_r($keys);
		//print_r($vals);

		Table_Update('w4u_transit',$keys,$vals);


		$keys=array(
			'h_fio_eta_new' => $_REQUEST["eta_new"],
			'fio_eta_new' => $eta_new,
			'm' => OraDate2MDBDate($_REQUEST['ml']),
			'new_eta_visible' => $_REQUEST['new_visible'],
			'id' => get_new_id()
		);
		Table_Update('w4u_pb_log',$keys,$keys);
	}
}

$sql = rtrim(file_get_contents('sql/w4u_admin_pb_month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ml', $res);

$p=array();
$p[':dpt_id'] = $_SESSION["dpt_id"];
$sql = rtrim(file_get_contents('sql/w4u_admin_pb_eta_list.sql'));
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('el', $res);

if (isset($_REQUEST["ml"]))
{


if ($_REQUEST['mode']=='auto')
{
$p=array();
$p[':dt'] = "'".$_REQUEST["ml"]."'";
$p[':h_fio_eta'] = "'".$_REQUEST["eta_old"]."'";
$sql = rtrim(file_get_contents('sql/w4u_admin_pb_get_akb_visible.sql'));
$sql=stritr($sql,$p);
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('head_old', $res);

$p=array();
$p[':dt'] = "'".$_REQUEST["ml"]."'";
$p[':h_fio_eta'] = "'".$_REQUEST["eta_old"]."'";
$sql = rtrim(file_get_contents('sql/w4u_admin_pb_get_prod.sql'));
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('data_old', $res);
}


$p=array();
$p[':dt'] = "'".$_REQUEST["ml"]."'";
$p[':h_fio_eta'] = "'".$_REQUEST["eta_new"]."'";
$sql = rtrim(file_get_contents('sql/w4u_admin_pb_get_akb_visible.sql'));
$sql=stritr($sql,$p);
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('head_new', $res);


$p=array();
$p[':dt'] = "'".$_REQUEST["ml"]."'";
$p[':h_fio_eta'] = "'".$_REQUEST["eta_new"]."'";
$sql = rtrim(file_get_contents('sql/w4u_admin_pb_get_prod.sql'));
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('data_new', $res);






$p=array();
$p[':dt'] = "'".$_REQUEST["ml"]."'";
$sql = rtrim(file_get_contents('sql/w4u_admin_pb_get_log.sql'));
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('log', $res);










}

$smarty->display('w4u_admin_pb.html');

?>