<?php

audit("открыл merch_report_vp","merch_report_vp");



if (isset($_REQUEST["save"])&&isset($_REQUEST["keys"]))
{
	foreach ($_REQUEST["keys"] as $k=>$v)
	{
		$keys=array('prod_id'=>$k);
		($v==1)?$vals=$_REQUEST["data"][$k]:$vals=null;
		Table_Update('merch_report_vp',$keys,$vals);
	}
}

$sql = rtrim(file_get_contents('sql/merch_report_vp.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pl', $res);

$smarty->display('merch_report_vp.html');

?>