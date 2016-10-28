<?php

//ses_req();


audit("открыл перечисления СПД","perech");

$sql = rtrim(file_get_contents('sql/dates_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dates_list', $res);

$sql = rtrim(file_get_contents('sql/perech_zat1.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('perech_zat1', $res);

$sql = rtrim(file_get_contents('sql/perech_zat2.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('perech_zat2', $res);



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $key => $val)
	{
		$keys = array('id'=>$key);
		Table_Update ("perech", $keys, null);
	}
}




if (isset($_REQUEST["add"]))
{
	$n=$_REQUEST["new"];
	$keys = array('tn'=>$n["tn"],'data'=>$n["data"]);
	$n["data"]=OraDate2MDBDate($n["data"]);
	$n['summa_p']=round($n["summa"]*($n["perc"]/100+1));
	Table_Update ("perech", $keys, $n);
}



$sql = rtrim(file_get_contents('sql/perech_spd_list.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list', $data);


!isset($_REQUEST["dates_list1"])?$_REQUEST["dates_list1"]=$_REQUEST["dates_list"]:null;
!isset($_REQUEST["dates_list2"])?$_REQUEST["dates_list2"]=$_REQUEST["dates_list"]:null;



$params=array(':dpt_id' => $_SESSION["dpt_id"],":dates_list1"=>"'".$_REQUEST["dates_list1"]."'",":dates_list2"=>"'".$_REQUEST["dates_list2"]."'");
$sql = rtrim(file_get_contents('sql/perech.sql'));
$sql=stritr($sql,$params);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('perech', $res);

$params=array(':dpt_id' => $_SESSION["dpt_id"],":dates_list1"=>"'".$_REQUEST["dates_list1"]."'",":dates_list2"=>"'".$_REQUEST["dates_list2"]."'");
$sql = rtrim(file_get_contents('sql/perech_total.sql'));
$sql=stritr($sql,$params);
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('perech_total', $res);


$smarty->display('perech.html');

?>