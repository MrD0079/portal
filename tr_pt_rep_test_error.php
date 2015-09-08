<?

//ses_req();

audit ("открыл отчет по тренингам test_error","tr");

InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
InitRequestVar("tr",0);


$params=array(
':tn'=>$tn,
':dpt_id' => $_SESSION["dpt_id"],
":sd"=>"'".$_REQUEST["dates_list1"]."'",
":ed"=>"'".$_REQUEST["dates_list2"]."'",
":tr"=>$_REQUEST["tr"],
);

$sql=rtrim(file_get_contents('sql/tr_pt.sql'));
$tr = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr', $tr);



if (isset($_REQUEST["select"]))
{

//print_r($params);

$sql=rtrim(file_get_contents('sql/tr_pt_rep_test_error_tbl.sql'));
$sql=stritr($sql,$params);


//echo $sql;

$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tbl', $r);



//print_r($r);

}


$smarty->display('tr_pt_rep_test_error.html');



?>