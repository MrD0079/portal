<?



audit ("открыл отчет по тренингам test_error_detail","tr");

InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
InitRequestVar("q_id");
InitRequestVar("tr");

$params=array(
':tn'=>$tn,
':dpt_id' => $_SESSION["dpt_id"],
":sd"=>"'".$_REQUEST["dates_list1"]."'",
":ed"=>"'".$_REQUEST["dates_list2"]."'",
':q_id' => $_REQUEST["q_id"],
':tr' => $_REQUEST["tr"],
);


$smarty->assign('tr_name', $db->getOne("select name from tr where id=".$_REQUEST["tr"]));
$smarty->assign('q_name', $db->getOne("select name from tr_test_qa where id_num=".$_REQUEST["q_id"]));


$sql=rtrim(file_get_contents('sql/tr_rep_test_error_detail.sql'));
$sql=stritr($sql,$params);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $r);

$smarty->display('tr_rep_test_error_detail.html');



?>