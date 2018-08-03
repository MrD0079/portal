<?
if (isset($_REQUEST["save"]))
{
	
	$id = get_new_id();
	$keys = array("id"=>$id);
	$_REQUEST['new']['tn']=$tn;
	$_REQUEST['new']['dpt_id']=$_SESSION["dpt_id"];
	Table_Update("scmovezay",$keys,$_REQUEST["new"]);
	echo '<p style="color:red">Заявка №'.$id.' добавлена и ожидает подтверждения</p>';
}
$smarty->assign('ffidtp', $db->getOne('SELECT id FROM bud_ru_ff WHERE admin_id = 4 and dpt_id='.$_SESSION["dpt_id"]));
$smarty->assign('ffidnet', $db->getOne('SELECT id FROM bud_ru_ff WHERE admin_id = 14 and dpt_id='.$_SESSION["dpt_id"]));
$smarty->display('scmovezay.html');
?>