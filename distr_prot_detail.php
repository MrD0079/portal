<?

//InitRequestVar('da_sd',$_REQUEST['month_list']);
//InitRequestVar('da_ed',$_REQUEST['month_list']);

$p = array();

$p[":tn"]=$tn;
$p[":da_conq"]=$_REQUEST["conq"];
$p[":dpt_id"]=$_SESSION["dpt_id"];
$p[':da_sd']="'".$_REQUEST['sd']."'";
$p[':da_ed']="'".$_REQUEST['ed']."'";

$sql=rtrim(file_get_contents('sql/distr_prot_detail.sql'));
$sql=stritr($sql,$p);
//echo $sql;
$r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $r);
//print_r($r);

$sql=rtrim(file_get_contents('sql/distr_prot_detail2.sql'));
$sql=stritr($sql,$p);
//echo $sql;
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d2', $r);
//print_r($r);


$smarty->display('distr_prot_detail.html');

?>