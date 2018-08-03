<?




InitRequestVar('da_db',0);
InitRequestVar('da_di',0);
InitRequestVar('da_re','0');
InitRequestVar('da_de','0');

audit("открыл distr_access","distr");
$p = array(":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);


$p[':da_db']=$_REQUEST['da_db'];
$p[':da_di']=$_REQUEST['da_di'];
$p[':da_re']="'".$_REQUEST['da_re']."'";
$p[':da_de']="'".$_REQUEST['da_de']."'";



$sql=rtrim(file_get_contents('sql/distr_access_db.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('da_db', $x);

$sql=rtrim(file_get_contents('sql/distr_access_di.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('da_di', $x);

$sql=rtrim(file_get_contents('sql/distr_access_re.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('da_re', $x);

$sql=rtrim(file_get_contents('sql/distr_access_de.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('da_de', $x);



if (isset($_REQUEST['refresh']))
{

$sql=rtrim(file_get_contents('sql/distr_access.sql'));
$sql=stritr($sql,$p);
//echo $sql;
$distr_access = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('distr_access', $distr_access);

}


$smarty->display('distr_access.html');

?>