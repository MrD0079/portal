<?

/*
$sql=rtrim(file_get_contents('sql/bud_fil.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$bud_fil = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_fil', $bud_fil);
*/

$p = array(":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=rtrim(file_get_contents('sql/distr_prot_di.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_fil', $x);



$sql=rtrim(file_get_contents('sql/distr_ownership.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ownership', $x);

$sql=rtrim(file_get_contents('sql/distr_activity.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('activity', $x);


$sql=rtrim(file_get_contents('sql/bud_fil_passport_get.sql'));
$p = array(":id" => $_REQUEST["id"]);
$sql=stritr($sql,$p);
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('p', $x);

$sql=rtrim(file_get_contents('sql/bud_fil_passport_contacts_get.sql'));
$p = array(":id" => $_REQUEST["id"]);
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('contacts', $x);

$sql=rtrim(file_get_contents('sql/bud_fil_passport_contracts_get.sql'));
$p = array(":id" => $_REQUEST["id"]);
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('contracts', $x);

$smarty->display('bud_fil_passport_get.html');


?>