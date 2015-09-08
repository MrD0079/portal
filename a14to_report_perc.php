<?php
	$params=array(
		':dpt_id' => $_SESSION["dpt_id"],
		':tn'=>$tn,
		':eta_list' => "'".$_REQUEST["eta_list"]."'",
		':dt' => "'".$_REQUEST["dt"]."'",
	);
	$sql=rtrim(file_get_contents('sql/a14to_report_total_perc.sql'));
	$sql=stritr($sql,$params);
	//echo $sql;
	$perc_ts = $db->getOne($sql);
	//echo $perc_ts;
	$smarty->assign('perc_ts', $perc_ts);
	$smarty->display('a14to_report_perc.html');
?>