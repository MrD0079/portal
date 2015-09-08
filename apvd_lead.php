<?php

//ses_req();


InitRequestVar("type",2); // по умолчанию считаем балл по С-В


$sql = rtrim(file_get_contents('sql/apvd_lead_rm.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"], ':type' => $_REQUEST["type"]);
$sql=stritr($sql,$p);
$drm = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($drm as $k => $v)
{
	$d[$v["tn"]]["head"]=$v;

	$sql = rtrim(file_get_contents('sql/apvd_lead_tm.sql'));
	$p = array(':dpt_id' => $_SESSION["dpt_id"],':tn' => $v["tn"], ':type' => $_REQUEST["type"]);
	$sql=stritr($sql,$p);
	$dtm = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

	foreach ($dtm as $k1 => $v1)
	{
		$d[$v["tn"]]["data_tm"][$v1["tn"]]=$v1;
	}

	$sql = rtrim(file_get_contents('sql/apvd_lead_ts.sql'));
	$p = array(':dpt_id' => $_SESSION["dpt_id"],':tn' => $v["tn"], ':type' => $_REQUEST["type"]);
	$sql=stritr($sql,$p);
	$dts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

	foreach ($dts as $k2 => $v2)
	{
		$d[$v["tn"]]["data_ts"][$v2["tn"]]=$v2;
	}

	$sql = rtrim(file_get_contents('sql/apvd_lead_eta.sql'));
	$p = array(':dpt_id' => $_SESSION["dpt_id"],':tn' => $v["tn"], ':type' => $_REQUEST["type"]);
	$sql=stritr($sql,$p);
	$deta = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

	foreach ($deta as $k3 => $v3)
	{
		$d[$v["tn"]]["data_eta"][$v3["fio_eta"]]=$v3;
	}
}




$smarty->assign('d', $d);
$smarty->display('apvd_lead.html');

//ses_req();

?>