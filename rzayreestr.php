<?
audit("открыл rzayreestr","rzayreestr");
InitRequestVar("nets");
InitRequestVar("tn_rmkk");
InitRequestVar("tn_mkk");
InitRequestVar("acceptstatus",0);
InitRequestVar("sendstatus",0);
InitRequestVar("sd",$_REQUEST["month_list"]);
InitRequestVar("ed",$_REQUEST["month_list"]);
if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		$keys = array("id"=>$k);
		//isset($v['act_prov_month'])?$v['act_prov_month']=OraDate2MDBDate($v['act_prov_month']):null;
		//isset($v['oplata_date'])?$v['oplata_date']=OraDate2MDBDate($v['oplata_date']):null;
		//isset($v['act_dt'])?$v['act_dt']=OraDate2MDBDate($v['act_dt']):null;
		Table_Update ("rzay", $keys, $v);
	}
	if (isset($_REQUEST["del"])){
		foreach ($_REQUEST["del"] as $k=>$v)
		{
			$keys = array("id"=>$k);
			Table_Update ("rzay", $keys, null);
		}
	}
}
/*
if (isset($_REQUEST["sendmsg"]))
{
	foreach ($_REQUEST["sendmsg"] as $k=>$v)
	{
		if (isset($_REQUEST["comm"][$k]))
		{
			if ($_REQUEST["comm"][$k]["comm"]!="")
			{
				$num=$db->getOne("select num from invoice where id=".$k);
				$data=$db->getOne("select TO_CHAR (data, 'dd.mm.yyyy') from invoice where id=".$k);
				$mail_mkk=$db->getOne("select e_mail from user_list where tn=(select tn_mkk from nets where id_net=(select id_net from invoice where id=".$k."))");
				$mail_rmkk=$db->getOne("select e_mail from user_list where tn=(select tn_rmkk from nets where id_net=(select id_net from invoice where id=".$k."))");
				$net_name=$db->getOne("select net_name from nets where id_net=(select id_net from invoice where id=".$k.")");
				$subj="Комментарий к счету $num от $data по сети $net_name. $mail_mkk $mail_rmkk";
				$text=nl2br($_REQUEST["comm"][$k]["comm"]);
				send_mail($mail_mkk,$subj,$text,null);
				send_mail($mail_rmkk,$subj,$text,null);
			}
		}
	}
}
*/
if (isset($_REQUEST["send"]))
{
	$sql=rtrim(file_get_contents('sql/rzayreestrsend.sql'));
	$params=array(
		':sd'=>"'".$_REQUEST["sd"]."'",
		':ed'=>"'".$_REQUEST["ed"]."'",
		':nets'=>$_REQUEST["nets"],
		':acceptstatus'=>$_REQUEST["acceptstatus"],
		':sendstatus'=>"'".$_REQUEST["sendstatus"]."'",
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':tn'=>$tn
	);
	$sql=stritr($sql,$params);
	//echo $sql;
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
}

if (isset($_REQUEST["generate"]))
{
	$sql=rtrim(file_get_contents('sql/rzayreestr.sql'));
	$sql_total=rtrim(file_get_contents('sql/rzayreestrtotal.sql'));
	$params=array(
		':sd'=>"'".$_REQUEST["sd"]."'",
		':ed'=>"'".$_REQUEST["ed"]."'",
		':nets'=>$_REQUEST["nets"],
		':acceptstatus'=>$_REQUEST["acceptstatus"],
		':sendstatus'=>"'".$_REQUEST["sendstatus"]."'",
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':tn'=>$tn
	);
	$sql=stritr($sql,$params);
	$sql_total=stritr($sql_total,$params);
	//echo $sql;
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data_total = $db->getRow($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($data as $k=>$v)
	{
		$data[$k]["files"] = $db->getAll("select * from rzayfiles where rzay=".$v["id"], null, null, null, MDB2_FETCHMODE_ASSOC);
	}
	$smarty->assign('invoice', $data);
	$smarty->assign('total', $data_total);
}

$sql=rtrim(file_get_contents('sql/nets.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql=rtrim(file_get_contents('sql/list_rmkk.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$list_rmkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_rmkk', $list_rmkk);

$sql=rtrim(file_get_contents('sql/list_mkk.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$list_mkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk', $list_mkk);

$sql=rtrim(file_get_contents('sql/urlic.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_urlic', $res);

$sql=rtrim(file_get_contents('sql/distr_prot_di_kk.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('payer', $data);

$smarty->display('rzayreestr.html');
?>