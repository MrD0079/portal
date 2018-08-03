<?



audit ("открыл отчет по тренингам common","tr");

InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
InitRequestVar("tr_pt_rep_common_datauvol",'all');

//':h_eta'=>"'".$_SESSION["h_eta"]."'",

$params=array(
':tn'=>$tn,
':dpt_id' => $_SESSION["dpt_id"],
":sd"=>"'".$_REQUEST["dates_list1"]."'",
":ed"=>"'".$_REQUEST["dates_list2"]."'",
':tr_pt_rep_common_datauvol'=>"'".$_REQUEST['tr_pt_rep_common_datauvol']."'",
);

$sql=rtrim(file_get_contents('sql/tr_pt_rep_common_select_pos.sql'));
$sql=stritr($sql,$params);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('select_pos', $r);

$sql=rtrim(file_get_contents('sql/tr_pt.sql'));
$sql=stritr($sql,$params);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('select_tr', $r);

if (isset($_REQUEST["select"]))
{


$sp=join($_REQUEST["sp"],',');
$st=join($_REQUEST["st"],',');


$smarty->assign('pos_all', $sp);
$smarty->assign('tr_pt_all', $st);



$params[":pos"]=$sp;
$params[":tr"]=$st;

//print_r($params);

$sql=rtrim(file_get_contents('sql/tr_pt_rep_common_tbl_top.sql'));
$sql=stritr($sql,$params);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tbl_top', $r);

$sql=rtrim(file_get_contents('sql/tr_pt_rep_common_tbl_cells.sql'));
$sql=stritr($sql,$params);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tbl_cells', $r);

$sql=rtrim(file_get_contents('sql/tr_pt_rep_common_tbl_bottom.sql'));
$sql=stritr($sql,$params);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tbl_bottom', $r);

$sql=rtrim(file_get_contents('sql/tr_pt_rep_common_tbl_right.sql'));
$sql=stritr($sql,$params);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tbl_right', $r);

$sql=rtrim(file_get_contents('sql/tr_pt_rep_common_tbl_total.sql'));
$sql=stritr($sql,$params);
$r = $db->getOne($sql);
$smarty->assign('tbl_total', $r);
}


$smarty->display('tr_pt_rep_common.html');



?>