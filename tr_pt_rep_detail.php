<?

//ses_req();

audit ("открыл отчет по тренингам detail","tr");

InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
InitRequestVar("pos");
InitRequestVar("tr");

$params=array(
':tn'=>$tn,
':dpt_id' => $_SESSION["dpt_id"],
":sd"=>"'".$_REQUEST["dates_list1"]."'",
":ed"=>"'".$_REQUEST["dates_list2"]."'",
':pos' => $_REQUEST["pos"],
':tr' => $_REQUEST["tr"],
);

$sql=rtrim(file_get_contents('sql/tr_pt_rep_detail.sql'));
$sql=stritr($sql,$params);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $r);

$smarty->display('tr_pt_rep_detail.html');



?>