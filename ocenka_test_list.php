<?php

$params=array(':dpt_id'=>$_SESSION['dpt_id']);

audit("����� � ������ �����������");

if (isset($_REQUEST["test_on"])) {
    foreach ($_REQUEST["test_on"] as $key => $val) {
        $sql = "insert into ocenka_test_list (tn) values (:tn)";
        $params = array(':tn' => $val);
        $sql=stritr($sql,$params);
        $db->query($sql);
	audit("������� ����������� ����� ��� ".$val);
    }
}


if (isset($_REQUEST["test_all_on"])) {
	$sql = rtrim(file_get_contents('sql/ocenka_test_all_off.sql'));
	$sql=stritr($sql,$params);
	$db->query($sql);
	//echo $sql;
	$sql = rtrim(file_get_contents('sql/ocenka_test_all_on.sql'));
	$sql=stritr($sql,$params);
	$db->query($sql);
	//echo $sql;
	audit("������� ����������� ����� ��� ����");
}
if (isset($_REQUEST["test_all_off"])) {
	$sql = rtrim(file_get_contents('sql/ocenka_test_all_off.sql'));
	$sql=stritr($sql,$params);
	$db->query($sql);
	audit("�������� ����������� ����� ��� ����");
}



if (isset($_REQUEST["test_length_save"])) {
	$db->query("update ocenka_test_length set test_length=".$_REQUEST["test_length"]);
	audit("������� ����������������� �����");
}

$test_length=$db->getOne("select test_length from ocenka_test_length");
$smarty->assign('test_length', $test_length);

$params=array(':dpt_id'=>$_SESSION['dpt_id']);

$sql = rtrim(file_get_contents('sql/ocenka_test_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('test_list', $data);

$smarty->display('ocenka_test_list.html');

?>