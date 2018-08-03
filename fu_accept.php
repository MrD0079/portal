<?
audit("открыл fu_accept","fin_plan");

InitRequestVar("nets",0);
InitRequestVar("calendar_years",0);
InitRequestVar("tn_rmkk",0);
InitRequestVar("tn_mkk",0);
InitRequestVar("calendar_months",0);
InitRequestVar("ok_filter",0);

//ini_set('display_errors', 1);

if (isset($_REQUEST["send_msg"])&&isset($_REQUEST["msg"]))
{
	foreach ($_REQUEST["msg"] as $k=>$v)
	{
		if ($v["msg"]!="")
		{
			$email_rmkk=$db->getOne("select e_mail from user_list where tn = (select tn_rmkk from nets where id_net=".$v["id_net"].")");
			$email_mkk=$db->getOne("select e_mail from user_list where tn = (select tn_mkk from nets where id_net=".$v["id_net"].")");
			$subj="Комментарий по факту ОУ сети ".$v["net_name"].", ".$v["mt"]." ".$_REQUEST["calendar_years"];
			$text="Здравствуйте,<br>";
			$text.=nl2br($v["msg"])."<br>";
			$text.="Сообщение отправил ".$fio." (".$tn.").<br>";
			send_mail($email_rmkk,$subj,$text,null);
			send_mail($email_mkk,$subj,$text,null);
			$keys=array(
				"id_net"=>$v["id_net"],
				"month"=>$v["my"],
				"year"=>$_REQUEST["calendar_years"]
			);
			$vals=array("msg"=>$v["msg"]);
			Table_Update("nets_plan_month_ok",$keys,$vals);
		}
	}
	$_REQUEST["generate"]=1;
}

if (
	(
	isset($_REQUEST["save"])
	||
	isset($_REQUEST["send_msg"])
	)
	&&
	isset($_REQUEST["ok"])
)
{
	foreach ($_REQUEST["ok"] as $k=>$v)
	{
		$keys["year"]=$_REQUEST["calendar_years"];
		$keys["plan_type"]=4;
		$keys["id_net"]=$k;
		foreach ($v as $k1=>$v1)
		{
			$keys["month"]=$k1;
			foreach ($v1 as $k2=>$v2)
			{
				if ($v2!="")
				{
					$vals=array($k2=>$v2);
					//print_r($keys);
					//print_r($vals);
					Table_Update ("nets_plan_month_ok", $keys, $vals);
				}
			}
		}
	}
	$_REQUEST["generate"]=1;
}

if (isset($_REQUEST["generate"]))
{
	$_SESSION["calendar_years"]=$_REQUEST["calendar_years"];
	$_SESSION["tn_rmkk"]=$_REQUEST["tn_rmkk"];
	$_SESSION["tn_mkk"]=$_REQUEST["tn_mkk"];
	$_SESSION["nets"]=$_REQUEST["nets"];
	$_SESSION["ok_filter"]=$_REQUEST["ok_filter"];
	$sql=rtrim(file_get_contents('sql/fu_accept.sql'));
	$sql_detail=rtrim(file_get_contents('sql/fu_accept_detail.sql'));
	$sql_detail_total=rtrim(file_get_contents('sql/fu_accept_detail_total.sql'));
	$params=array(
		':dpt_id' => $_SESSION["dpt_id"],
		':y'=>$_REQUEST["calendar_years"],
		':nets'=>$_REQUEST["nets"],
		':ok_filter'=>$_REQUEST["ok_filter"],
		':calendar_months'=>$_REQUEST["calendar_months"],
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':tn'=>$tn
	);
	$sql=stritr($sql,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($data as $k=>$v)
	{
		$params[":calendar_months"]=$v["my"];
		$params[":nets"]=$v["id_net"];
		$data[$k]["detail"] = $db->getAll(stritr($sql_detail,$params), null, null, null, MDB2_FETCHMODE_ASSOC);
		$d = $db->getAll(stritr($sql_detail_total,$params), null, null, null, MDB2_FETCHMODE_ASSOC);
		$data[$k]["detail_total"] = $d[0];
		for($i=1;$i<=4;$i++)
		{
		$sql1=rtrim(file_get_contents("sql/fin_plan_one_month_".$i.".sql"));
		$params1=array(
			':y'=>$_REQUEST["calendar_years"],
			":plan_type" => $i,
			":plan_month" => $v["my"],
			':net'=>$v["id_net"]
		);
		$sql1=stritr($sql1,$params1);
		$data1 = $db->getRow($sql1, null, null, null, MDB2_FETCHMODE_ASSOC);
		$data[$k]["plan".$i] = $data1;
		}
	}
	//print_r($data);
	$smarty->assign('fin_report', $data);
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

$smarty->display('kk_start.html');
$smarty->display('fu_accept.html');
$smarty->display('kk_end.html');



?>