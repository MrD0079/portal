<?

$sql=rtrim(file_get_contents('sql/distr_prot_conq_show_fils.sql'));
$p = array(":conq_id" => $_REQUEST["conq_id"],":dpt_id" => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('fils', $r);
$smarty->display('distr_prot_conq_show_fils.html');


?>