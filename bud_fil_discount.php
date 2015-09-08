<?

//ses_req();

if (isset($_REQUEST['save']))
{
	
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('dt'=>OraDate2MDBDate($_REQUEST['dt']));
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	$_REQUEST['table']=='body'?$keys['distr']=$_REQUEST['key2']:null;
	//$_REQUEST['table']=='body'&&$_REQUEST['val']==null&&$_REQUEST['field']=='distr'?$vals=null:null;
	/*
	echo 'bud_fil_discount_'.$_REQUEST['table'];
	print_r($keys);
	print_r($vals);
	*/
	Table_Update('bud_fil_discount_'.$_REQUEST['table'], $keys,$vals);
}
else
{

InitRequestVar("sd",$_SESSION["month_list"]);
InitRequestVar("db",0);
InitRequestVar("cluster",0);
InitRequestVar("distr",0);
audit("открыл скидки дистрибьюторов за ".$_REQUEST["sd"],"bud_fil_discount");

$p = array(
':sd'=>"'".$_REQUEST["sd"]."'",
":tn"=>$tn,
":db"=>$_REQUEST["db"],
":clusters"=>$_REQUEST["cluster"],
":distr"=>$_REQUEST["distr"],
":dpt_id"=>$_SESSION["dpt_id"],
':fil_activ'=>1
);


//InitRequestVar("copy_discount",0);

if (isset($_REQUEST['copy_discount']))
{
if ($_REQUEST['copy_discount']==1)
{
	//ses_req();
	audit("скопировал скидки дистрибьюторов из ".$_REQUEST["fd"]." в ".$_REQUEST["sd"],"bud_fil_discount");
	$p[':dt_to']="'".$_REQUEST["sd"]."'";
	$p[':dt_from']="'".$_REQUEST["fd"]."'";
	$sql = rtrim(file_get_contents('sql/bud_fil_discount_copy.sql'));
	$sql=stritr($sql,$p);
	$db->query($sql);
	//echo $sql;
}
}


$sql = rtrim(file_get_contents('sql/bud_fil.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('fil', $data);

$sql = rtrim(file_get_contents('sql/bud_db_list.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('db', $data);

$sql = rtrim(file_get_contents('sql/clusters.sql'));
$sql = stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('clusters', $r);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

foreach($res as $k=>$v){if ($v["sd_c"]==$_REQUEST["sd"]){$period=$v["my"];}}
$m=substr($_REQUEST["sd"], 3, 2);
$y=substr($_REQUEST["sd"], 6, 4);
$smarty->assign('period', $period);

$sql = rtrim(file_get_contents('sql/bud_fil_discount_head.sql'));
$sql=stritr($sql,$p);
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('head', $x);

$sql = rtrim(file_get_contents('sql/bud_fil_discount_body.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('body', $x);

}

if (isset($_REQUEST['save']))
{
	if ($_REQUEST['field']=='dpu_tn'&&$_REQUEST['val']!='')
	{
		$period=$db->getOne("select mt||' '||y from calendar where data=to_date('".$_REQUEST['dt']."','dd.mm.yyyy')");
		$subj='Скидки дистрибуторов за '.$period;
		$sql="SELECT fio, e_mail FROM user_list WHERE (is_traid = 1 OR is_traid_kk = 1) AND dpt_id = ".$_SESSION["dpt_id"]." AND datauvol IS NULL";
		$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		foreach ($x as $k=>$v){send_mail($v['e_mail'],$subj,'Скидки дистрибуторов за '.$period.' согласованы ЗГДП',null);}
	}
}
else
{
	$smarty->display('bud_fil_discount.html');
}
?>