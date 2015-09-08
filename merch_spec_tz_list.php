<?


//$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);



InitRequestVar("routes_agents",0);
InitRequestVar("merch_spec_nets",0);
InitRequestVar("merch_spec_oblast","0");
//InitRequestVar("spec_join","0");
InitRequestVar("merch_spec_sd",$now);
InitRequestVar("merch_spec_tz","0");

//ses_req();
//

$p=array();


$p[":net"] = $_REQUEST["merch_spec_nets"];
$p[":oblast"] = "'".$_REQUEST["merch_spec_oblast"]."'";

$sql = rtrim(file_get_contents('sql/merch_spec_tz_list.sql'));
$sql=stritr($sql,$p);


//echo $sql;


$tz_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tz_list', $tz_list);


$smarty->display('merch_spec_tz_list.html');


?>