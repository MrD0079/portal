<?php

//ses_req();


if (isset($_REQUEST["d"]))
{
	foreach ($_REQUEST["d"] as $key => $val)
	{
	foreach ($val as $key1 => $val1)
	{
		$keys=array("fio_eta"=>$key,"tab_num"=>$key1);
		Table_Update("apvd12_eta",$keys,$val1);
	}
	}
}

$sql = rtrim(file_get_contents('sql/apvd12_eta.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $data);
$smarty->display('apvd12_eta.html');

//ses_req();

?>