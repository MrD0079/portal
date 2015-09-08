<?
$p=array(':sd'=>"'".$_REQUEST["dt"]."'",":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
if (isset($_REQUEST['msg']))
{
	$keys = array('dt'=>OraDate2MDBDate($_REQUEST['dt']));
	$vals = array('msg'=>$_REQUEST['msg']);
	$keys['dpt_id']=$_SESSION['dpt_id'];
	$keys['id']=get_new_id();
	$keys['lu_tn']=$tn;
	$keys['lu_fio']=$fio;
	Table_Update('kcm_chat', $keys,$vals);
	$x=$db->getOne("select mt||' '||y from calendar where data=to_date('".$_REQUEST['dt']."','dd.mm.yyyy')");
	$subj='Комментарии по КПР департамента персонала за '.$x;
	$text=$fio." оставил следующий комментарий:<br>".nl2br($_REQUEST['msg']);
	$sql="SELECT fio, e_mail FROM user_list WHERE 1 IN (is_ndp, is_dpu, is_acceptor) AND dpt_id = ".$_SESSION["dpt_id"]." AND tn <> ".$tn." AND datauvol IS NULL";
	$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($x as $k=>$v){send_mail($v['e_mail'],$subj,$text,null);}
}
$sql = rtrim(file_get_contents('sql/kcm_chat.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('chat', $x);
$smarty->display('kcm_chat.html');
?>