<?php



//ses_req();

InitRequestVar('all',1);



audit("вошел в список экспертов");

if (isset($_REQUEST['exp_dep']))
{

    $sql = "begin exp_dep (:p_exp,:p_dep) ; end;";
    $statement = $db->prepare($sql);
    $res = $statement->execute($_REQUEST["exp_dep_params"]);
    if (PEAR::isError($res)) { echo $res->getMessage(); }
    audit("добавил эксперта ".$_REQUEST["exp_dep_params"]["p_exp"]." в подразделение ".$_REQUEST["exp_dep_params"]["p_dep"]);
}

if (isset($_REQUEST['exp_reg']))
{

    $sql = "begin exp_reg (:p_exp,:p_reg) ; end;";
    $statement = $db->prepare($sql);
    $res = $statement->execute($_REQUEST["exp_reg_params"]);
    if (PEAR::isError($res)) { echo $res->getMessage(); }
    audit("добавил эксперта ".$_REQUEST["exp_reg_params"]["p_exp"]." в регион ".$_REQUEST["exp_reg_params"]["p_reg"]);
}



if (isset($_REQUEST["drop"])) {
    $sql = rtrim(file_get_contents('sql/emp_exp_drop.sql'));
    $p = array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$_REQUEST["drop_exp"]);
    $sql=stritr($sql,$p);
    $res = $db->query($sql);
    //echo $sql;
    if (PEAR::isError($res)) { echo $res->getMessage(); }
    audit("отвязал эксперта: ".$_REQUEST["drop_exp"]);
}

if (isset($_REQUEST["new"])) {
    $sql = "select fn_emp_exp_ins (:emp_tn,:exp_tn,:full) from dual";
    $statement = $db->prepare($sql);
    $res = $statement->execute($_REQUEST["add"]);
    if (PEAR::isError($res)) { echo $res->getMessage(); }
    audit("добавил запись в список экспертов emp_tn: ".$_REQUEST["add"]["emp_tn"]." exp_tn: ".$_REQUEST["add"]["exp_tn"]);
}

if (isset($_REQUEST["del"])) {
   foreach ($_REQUEST["del"] as $key => $val)
   {
    $a = explode(",", $val);
    $params = array(
     'emp_tn' => $a[0],
     'exp_tn' => $a[1]
    );
    $sql = "select fn_empexpdel (:emp_tn,:exp_tn) from dual";
    $statement = $db->prepare($sql);
    $res = $statement->execute($params);
    if (PEAR::isError($res)) { echo $res->getMessage(); }
    audit("удалил запись из списка экспертов emp_tn: ".$a[0]." exp_tn: ".$a[1]);
   }
}

if (isset($_REQUEST["replace"]))
{
	if (($_REQUEST["replace_exp"]["exp_from"]!='')&&($_REQUEST["replace_exp"]["exp_to"]!=''))
	{
		$sql = "select fn_emp_exp_replace (:exp_from,:exp_to) from dual";
		$statement = $db->prepare($sql);
		$res = $statement->execute($_REQUEST["replace_exp"]);
		if (PEAR::isError($res)) { echo $res->getMessage(); }
		audit("изменил эксперта ".$_REQUEST["replace_exp"]["exp_from"]."=>".$_REQUEST["replace_exp"]["exp_to"]);
	}
}

$sql = rtrim(file_get_contents('sql/emp_exp.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"],':flt'=>$_REQUEST["all"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('emp_exp', $data);

$sql = rtrim(file_get_contents('sql/emp_exp_wo_full.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"],':flt'=>$_REQUEST["all"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('emp_exp_wo_full', $data);

$sql = rtrim(file_get_contents('sql/emp_exp_spd_list_full.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"],':flt'=>$_REQUEST["all"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list', $data);

$sql = rtrim(file_get_contents('sql/emp_exp_spd_list_full.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"],':flt'=>$_REQUEST["all"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list_full', $data);


$sql = rtrim(file_get_contents('sql/emp_exp_department_list.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('department_list', $data);

$sql = rtrim(file_get_contents('sql/emp_exp_region_list.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('region_list', $data);



$smarty->display('emp_exp.html');



?>