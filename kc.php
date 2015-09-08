<?
if (isset($_REQUEST['save']))
{
	
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('dt'=>OraDate2MDBDate($_REQUEST['dt']));
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	$_REQUEST['table']=='m'?$keys['dpt_id']=$_SESSION['dpt_id']:null;
	$_REQUEST['table']=='c'||$_REQUEST['table']=='ct'?$keys['coach']=$_REQUEST['key2']:null;
	($_REQUEST['table']=='c'||$_REQUEST['table']=='ct')&&$_REQUEST['val']==null&&$_REQUEST['field']=='coach'?$vals=null:null;
	$_REQUEST['table']=='ct'?$keys['id']=$_REQUEST['key3']:null;
	Table_Update('kc'.$_REQUEST['table'], $keys,$vals);
}
else
if (isset($_REQUEST['add_task']))
{
}
else
if (isset($_REQUEST['del_task']))
{
	Table_Update('kcct', array('id'=>$_REQUEST["id"]),null);
}
else
{
$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

InitRequestVar("sd",$_SESSION["month_list"]);
audit("открыл КПР тренеров за ".$_REQUEST["sd"],"kc");
foreach($res as $k=>$v){if ($v["sd_c"]==$_REQUEST["sd"]){$period=$v["my"];}}
$m=substr($_REQUEST["sd"], 3, 2);
$y=substr($_REQUEST["sd"], 6, 4);
$smarty->assign('period', $period);
$p=array(':sd'=>"'".$_REQUEST["sd"]."'",":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);

$sql = rtrim(file_get_contents('sql/kcm.sql'));
$sql=stritr($sql,$p);
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('kcm', $x);

$sql = rtrim(file_get_contents('sql/kcc.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('kcc', $x);

$sql = rtrim(file_get_contents('sql/kcc_tbl.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$sqlt = rtrim(file_get_contents('sql/kcc_tbl_tasks.sql'));
foreach($x as $k=>$v)
{
$p[":coach"]=$v["coach"];
$sqlt1=stritr($sqlt,$p);
$x[$k]["tasks"] = $db->getAll($sqlt1, null, null, null, MDB2_FETCHMODE_ASSOC);
}
$smarty->assign('kcc_tbl', $x);
//print_r($x);

$sql = rtrim(file_get_contents('sql/kcc_tbl_total.sql'));
$sql=stritr($sql,$p);
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('kcc_tbl_total', $x);
}

if (isset($_REQUEST['save']))
{
	if ($_REQUEST['field']=='ok_dpu_tn'&&$_REQUEST['val']!='')
	{
		$accept1=$parameters["accept1"]["val_string"];
		$accept2=$parameters["accept2"]["val_string"];
		$period=$db->getOne("select mt||' '||y from calendar where data=to_date('".$_REQUEST['dt']."','dd.mm.yyyy')");
		$subj='КПР департамента персонала за '.$period;
		$text = $smarty->fetch('kc.html');
		send_mail($accept1,$subj,$text,null);
		send_mail($accept2,$subj,$text,null);
		$sql="SELECT fio, e_mail FROM user_list WHERE is_ndp = 1 AND dpt_id = ".$_SESSION["dpt_id"]." AND datauvol IS NULL";
		$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		foreach ($x as $k=>$v){send_mail($v['e_mail'],$subj,'Отчет за '.$period.' согласован ЗГДП',null);}
	}
}
else
if (isset($_REQUEST['add_task']))
{
	if ($_REQUEST["id"]=='null')
	{
		$smarty->assign('id', get_new_id());
	}
	else
	{
		$smarty->assign('id', $_REQUEST["id"]);
		$sql = rtrim(file_get_contents('sql/kcc_tbl_task.sql'));
		$p = array(":id"=>$_REQUEST["id"]);
		$sql=stritr($sql,$p);
		$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('task', $x);
	}
	$smarty->display('kc_add_task.html');
}
else
{
	$smarty->display('kc.html');
}
?>