<?

$p = array(":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);
$p[':cat']=$_REQUEST['cat'];

$sql=rtrim(file_get_contents('sql/distr_prot_conq_filter.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('conq', $x);

$smarty->display('distr_prot_conq_filter.html');

?>