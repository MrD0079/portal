<?

audit("������ invoicep_reestr","invoicep_reestr");

InitRequestVar("nets",0);
InitRequestVar("calendar_years",0);
InitRequestVar("tn_rmkk",0);
InitRequestVar("tn_mkk",0);
InitRequestVar("calendar_months",0);
InitRequestVar("format",0);
InitRequestVar("payment_type",0);
InitRequestVar("okfm","all");
InitRequestVar("oplata_date_s");
InitRequestVar("oplata_date_e");
InitRequestVar("act_prov_month_s");
InitRequestVar("act_prov_month_e");
InitRequestVar("ip_z_id",0);

if (isset($_REQUEST["add"]))
{
	$v=$_REQUEST["new"];
	if
	(
		($v["id_net"]!="")&&
		($v["num"]!="")&&
		($v["data"]!="")&&
		($v["payer"]!="")&&
		($v["summa"]!="")
	)
	{
		$v["data"]=OraDate2MDBDate($v["data"]);
		$v["promo"]=1;
		$id=get_new_id();
		$v["id"]=$id;
		Table_Update("invoice",$v,$v);
		if (isset($_FILES['new_files']))
		{
			foreach($_FILES['new_files']['name'] as $k=>$v)
			{
				if
				(
					is_uploaded_file($_FILES['new_files']['tmp_name'][$k])
				)
				{
					$a=pathinfo($_FILES['new_files']['name'][$k]);
					$fn=get_new_file_id().'_'.translit($_FILES['new_files']['name'][$k]);
					$vals=array(
						'invoice'=>$id,
						'fn'=>$fn
					);
					Table_Update('invoice_files', $vals,$vals);
					move_uploaded_file($_FILES['new_files']['tmp_name'][$k], 'files/'.$fn);
				}
			}
		}
	}
	else
	{
		echo "<p style=\"color:red\">�� ��� ���� ���������, ������ �� ���������!</p>";
	}
}

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		$keys["id"]=$k;
		foreach ($v as $k1=>$v1)
		{
			//if ($v1!="")
			//{
				$k1=="oplata_date"||$k1=="act_prov_month"?$v1=OraDate2MDBDate($v1):null;
				$vals=array($k1=>$v1);
				//print_r($keys);
				//print_r($vals);
				Table_Update ("invoice", $keys, $vals);
			//}
		}
	}
}

if (isset($_FILES['files']))
{
	foreach($_FILES['files']['name'] as $k=>$v)
	{
	foreach($v as $k1=>$v1)
	{
		if
		(
			is_uploaded_file($_FILES['files']['tmp_name'][$k][$k1])
		)
		{
			$a=pathinfo($_FILES['files']['name'][$k][$k1]);
			$fn=get_new_file_id().'_'.translit($_FILES['files']['name'][$k][$k1]);
			$vals=array(
				'invoice'=>$k,
				'fn'=>$fn
			);
			Table_Update('invoice_files', $vals,$vals);
			move_uploaded_file($_FILES['files']['tmp_name'][$k][$k1], 'files/'.$fn);
		}
	}
	}
}


if (isset($_REQUEST["del_files"]))
{
	foreach ($_REQUEST["del_files"] as $k=>$v)
	{
                Table_Update("invoice_files", array('id'=>$v),null);
	}
}

if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_Update("invoice", array('id'=>$v),null);
	}
}

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
				$subj="����������� � ����� $num �� $data �� ���� $net_name. $mail_mkk $mail_rmkk";
				$text=nl2br($_REQUEST["comm"][$k]["comm"]);
				send_mail($mail_mkk,$subj,$text,null);
				send_mail($mail_rmkk,$subj,$text,null);
			}
		}
	}
}

if (($_REQUEST["calendar_years"]!=0)&&(isset($_REQUEST["generate"])))
{
	$sql=rtrim(file_get_contents('sql/invoicep_reestr.sql'));
	$sql_detail=rtrim(file_get_contents('sql/invoicep_reestr_detail.sql'));
	$sql_files=rtrim(file_get_contents('sql/invoicep_files.sql'));
	$params=array(
		':y'=>$_REQUEST["calendar_years"],
		':nets'=>$_REQUEST["nets"],
		':format'=>$_REQUEST["format"],
		':okfm'=>"'".$_REQUEST["okfm"]."'",
		':calendar_months'=>$_REQUEST["calendar_months"],
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':payment_type'=>$_REQUEST["payment_type"],
		":oplata_date_s"=>"'".$_REQUEST["oplata_date_s"]."'",
		":oplata_date_e"=>"'".$_REQUEST["oplata_date_e"]."'",
		":act_prov_month_s"=>"'".$_REQUEST["act_prov_month_s"]."'",
		":act_prov_month_e"=>"'".$_REQUEST["act_prov_month_e"]."'",
		':z_id'=>$_REQUEST["ip_z_id"],
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
		$data[$k]["files"] = $db->getAll(stritr($sql_files,$params), null, null, null, MDB2_FETCHMODE_ASSOC);
	}
	//print_r($data);
	$smarty->assign('invoice', $data);
}

$sql=rtrim(file_get_contents('sql/distr_prot_di_kk.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('payer', $data);

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

$sql=rtrim(file_get_contents('sql/payment_type_zakaz_nal.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('payment_type', $data);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$smarty->display('kk_start.html');
$smarty->display('invoicep_reestr.html');
$smarty->display('kk_end.html');

?>