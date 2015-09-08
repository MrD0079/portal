<?

$p = array(":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);



$sql=rtrim(file_get_contents('sql/distr_prot_di.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('da_di', $x);


$smarty->display('distr_passport.html');


?>