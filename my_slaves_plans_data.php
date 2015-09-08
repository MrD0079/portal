<?

audit("открыл план активности подчиненных на дату ".$_REQUEST["dates_list"],"activ");




$params = array
(
    ':exp_tn' => $tn,
    ':data' => "'".$_REQUEST["dates_list"]."'",
    ':dpt_id'=>$_SESSION["dpt_id"]
    );
$sql = rtrim(file_get_contents('sql/my_slaves_plans_data.sql'));
$sql=stritr($sql,$params);

//echo $sql;

//$my_slaves_plans_data = &$db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);

$my_slaves_plans_data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);





//print_r($my_slaves_plans_data);


if (PEAR::isError($my_slaves_plans_data)) { echo $my_slaves_plans_data->getMessage(); }


$smarty->assign('my_slaves_plans_data', $my_slaves_plans_data);



$smarty->display('my_slaves_plans_data.html');



?>