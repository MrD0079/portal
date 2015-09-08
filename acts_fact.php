<?
if (isset($_REQUEST['save']))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('id'=>$_REQUEST['id']);
	$_REQUEST['field']=='act_prov_month'?$_REQUEST['val']=OraDate2MDBDate($_REQUEST['val']):null;
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	Table_Update('invoice', $keys,$vals);
}
else
{
	audit("открыл acts_fact","acts_fact");
	InitRequestVar("nets",0);
	InitRequestVar("calendar_years",0);
	InitRequestVar("tn_rmkk",0);
	InitRequestVar("tn_mkk",0);
	InitRequestVar("calendar_months",0);
	InitRequestVar("okact","all");
	if (isset($_REQUEST["generate"]))
	{
		$sql=rtrim(file_get_contents('sql/acts_fact.sql'));
		$sql_detail=rtrim(file_get_contents('sql/acts_fact_detail.sql'));
		$params=array(
			':y'=>$_REQUEST["calendar_years"],
			':nets'=>$_REQUEST["nets"],
			':okact'=>"'".$_REQUEST["okact"]."'",
			':calendar_months'=>$_REQUEST["calendar_months"],
			':tn_rmkk'=>$_REQUEST["tn_rmkk"],
			':tn_mkk'=>$_REQUEST["tn_mkk"],
			':tn'=>$tn
		);
		$sql=stritr($sql,$params);
		//echo $sql;
		$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		foreach ($data as $k=>$v)
		{
			//echo $v["id_net"]."-".$v["my"]."<br>";
			$params[":invoice"]=$v["id"];
			$data[$k]["detail"] = $db->getAll(stritr($sql_detail,$params), null, null, null, MDB2_FETCHMODE_ASSOC);
		}
		//print_r($data);
		$smarty->assign('invoice', $data);
	}
	$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('calendar_years', $data);
	$sql=rtrim(file_get_contents('sql/calendar_months.sql'));
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('calendar_months', $data);
	$sql=rtrim(file_get_contents('sql/nets.sql'));
	$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
	$sql=stritr($sql,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('nets', $data);
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
	$sql = rtrim(file_get_contents('sql/month_list.sql'));
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('month_list', $res);
	$smarty->display('acts_fact.html');
}
?>