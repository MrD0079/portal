<?php

audit("открыл dimproduct","dimproduct");



if (isset($_REQUEST["save"])&&isset($_REQUEST["keys"]))
{
	foreach ($_REQUEST["keys"] as $k=>$v)
	{
		$keys=array('prod_id'=>$k);
		($v==1)?$vals=$_REQUEST["data"][$k]:$vals=null;
		Table_Update('dimproduct_vp',$keys,$vals);
	}
}

$sql = rtrim(file_get_contents('sql/dimproduct.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pl', $res);

$smarty->display('dimproduct.html');

?>