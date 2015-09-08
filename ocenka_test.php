<?php


$test_enabled=$db->getOne("select count(*) from ocenka_test_list where tn=".$tn);
$smarty->assign('test_enabled', $test_enabled);

$params = array
(
$tn,
);

$sth = $db->prepare("delete from ocenka_test_list where tn=?");
$sth->execute($params);




$event=$db->getOne("select max(year) from ocenka_events where disabled=0");



if (isset($_REQUEST["ans"]))
{
    $params = array
    (
        $tn,
        $event,
        );
    unset($alldata);
    $sth = $db->prepare('delete from ocenka_score where exp_tn=? and event=? and criteria=?');
    foreach ($_REQUEST["ans"] as $key => $val) {
        $params4score = $params;
        $params4score[] = $key;
        $alldata[] = $params4score;
	$sth->execute($params4score);
    }
    unset($alldata);
    $sth = $db->prepare('insert into ocenka_score (exp_tn,event,criteria,score) values (?,?,?,?)');
    foreach ($_REQUEST["ans"] as $key => $val) {
        $params4score = $params;
        $params4score[] = $key;
	$true_answer=$db->getone("select weight from ocenka_criteria where id_num=".$val);
        $params4score[] = $true_answer;
        $alldata[] = $params4score;
	$sth->execute($params4score);
    }
  audit("закончил прохождение теста","ocenka");
}
else
{
  audit("запустил прохождение теста","ocenka");
}



if (!isset($_REQUEST["timeout"]))
{

$test_length=$db->getOne("select test_length from ocenka_test_length");
$smarty->assign('test_length', $test_length);

$sql = rtrim(file_get_contents('sql/ocenka_criteria.sql'));
$params=array($event,5,0);
//$data = &$db->getAssoc($sql, false, $params, MDB2_FETCHMODE_ASSOC);
$data = $db->getAll($sql, null, $params, null, MDB2_FETCHMODE_ASSOC);
//print_r($data);
foreach ($data as $key=>$val)
{
$sql = rtrim(file_get_contents('sql/ocenka_criteria.sql'));
$params=array($event,6,$val["id_num"]);
//$data1 = &$db->getAssoc($sql, false, $params, MDB2_FETCHMODE_ASSOC);
$data1 = $db->getAll($sql, null, $params, null, MDB2_FETCHMODE_ASSOC);
$data[$key]["ans"]=$data1;
}

$smarty->assign('test', $data);
}




$smarty->display('ocenka_test.html');


?>