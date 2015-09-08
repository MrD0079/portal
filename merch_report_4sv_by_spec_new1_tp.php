<?

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);





//InitRequestVar("exp_list_without_ts",0);
//InitRequestVar("exp_list_only_ts",0);
//InitRequestVar("eta_list",$_SESSION["h_eta"]);
//InitRequestVar("ok_bonus",1);
/*
InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("ok_bonus",1);
*/

//ses_req();

$p = array(
	':dpt_id' => $_SESSION["dpt_id"],
	":sd"=>"'".$_REQUEST["sd"]."'",
	":ed"=>"'".$_REQUEST["ed"]."'",
	":city"=>"'".$_REQUEST["city"]."'",
	":oblast"=>"'".$_REQUEST["oblast"]."'",
	":nets"=>$_REQUEST["nets"],
	":tn"=>$tn
);


$sql = rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new1_tp.sql'));
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $res);



$smarty->display('merch_report_4sv_by_spec_new1_tp.html');

//ses_req();

?>