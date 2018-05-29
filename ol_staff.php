<?

InitRequestVar("exp_list_without_ts",0);

$params=array(':dpt_id' => $_SESSION["dpt_id"],
	':tn'=>$tn,
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"]
);

$sql = rtrim(file_get_contents('sql/ol_staff_chief_list.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

if (isset($_REQUEST['save'])&&isset($_REQUEST['data']))
{
	foreach ($_REQUEST["data"] as $koa=>$voa)
	{
		Table_Update("ol_staff",array("id"=>$koa),$voa);
		if (isset($voa["accepted"]))
		{
			if ($voa["accepted"]==1)
			{
				$o = $db->getOne("SELECT free_staff_id FROM ol_staff WHERE id = ".$koa);
				$r = $db->getOne("SELECT COUNT (*) - SUM (accepted) FROM ol_staff WHERE free_staff_id                           = (SELECT free_staff_id FROM ol_staff WHERE id = ".$koa.")");
				$f = $db->getOne("SELECT fio FROM user_list WHERE tn = (SELECT tn FROM free_staff WHERE id                      = (SELECT free_staff_id FROM ol_staff WHERE id = ".$koa."))");
				$s = $db->getOne("SELECT NVL (SUM (sum_minus), 0) - NVL (SUM (sum_plus), 0) FROM ol_staff WHERE free_staff_id   = (SELECT free_staff_id FROM ol_staff WHERE id = ".$koa.")");
				$d = $db->getOne("SELECT TO_CHAR (MAX (accepted_dt), 'dd.mm.yyyy hh24:mi:ss') FROM ol_staff WHERE free_staff_id = (SELECT free_staff_id FROM ol_staff WHERE id = ".$koa.")");
//$r=0;
				if ($r==0)
				{
					$_GET["ol_arch_id"]=$o;
					$_POST["ol_arch_id"]=$o;
					$_REQUEST["ol_arch_id"]=$o;
					$_REQUEST["print"]=1;
					$_REQUEST["select"]=1;
					include "ol_arch.php";
					$fn=array("files/ol_files/attach".$o.".pdf");
					$accept1=$parameters["accept1"]["val_string"];
					$accept2=$parameters["accept2"]["val_string"];
					$subj="Завершено подписание обходного листа по сотруднику ".$f;
					$text=$d." было завершено согласование обходного листа по сотруднику ".$f.".<br>";
					$text.="Итоговая сумма к удержанию ".$s.".<br>";
					$text.="Детализацию вы можете посмотреть в разделе Реестры / Обходные листы";
					send_mail($accept1,$subj,$text,$fn);
					send_mail($accept2,$subj,$text,$fn);
				}
				else
				{
					$sql = rtrim(file_get_contents('sql/ol_staff_this_gr_ok.sql'));
					$sql = stritr($sql, array(':id'=>$koa));
					$this_gr_ok = $db->getOne($sql);
					if ($this_gr_ok==1)
					{
						$sql = rtrim(file_get_contents('sql/ol_staff_prev_ok.sql'));
						$sql = stritr($sql, array(':id'=>$koa));
						$prev = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
						$t='На данный момент согласование выставлено:<br>';
						foreach ($prev as $koap=>$voap)
						{
							$t.=$voap['fio'].',<br>';
							$t.=$voap['pos_name'].', сумма - '.$voap['summa'].'. Дата выставления подтверждения - '.$voap['accepted_dt'].'<br>';
						}
						$sql = rtrim(file_get_contents('sql/ol_staff_next_gr.sql'));
						$sql = stritr($sql, array(':id'=>$koa));
						$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
						foreach ($d as $koa1=>$voa1)
						{
							$subj="Сформирован обходной лист по увольняемому сотруднику - ".$voa1["staff_fio"];
							$text=$subj.".<br>Вы являетесь участником процесса заполнения обходного листа в разделе ".$voa1["cat"].".<br>";
							$text.=$t;
							send_mail($voa1["e_mail"],$subj,$text,null);
						}
					}
				}
			}
		}
	}
}

$sql=rtrim(file_get_contents('sql/ol_staff_head.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($data as $koa=>$voa)
{
	$p = array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':id' => $voa["id"]);
	$sql=rtrim(file_get_contents('sql/ol_staff_body.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($data1 as $koa1=>$voa1)
	{
		$data[$koa]['body'][$voa1["gruppa"]]["gruppa"]=$voa1["gruppa"];
		$data[$koa]['body'][$voa1["gruppa"]]["gr_name"]=$voa1["gr_name"];
		$data[$koa]['body'][$voa1["gruppa"]]["data"][$koa1]=$voa1;
		$fl = $db->getAll('select * from ol_staff_files where ol_staff_id='.$voa1["id"], null, null, null, MDB2_FETCHMODE_ASSOC);
		$data[$koa]['body'][$voa1["gruppa"]]["data"][$koa1]["fl"]=$fl;
	}

	$params=array(':tn' => $voa["tn"]);
	$sql=rtrim(file_get_contents('sql/tmc.sql'));
	$sql=stritr($sql,$params);
	$tmc = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data[$koa]['tmc']=$tmc;
}
//print_r($data);
$smarty->assign('ol_staff', $data);
$smarty->display('ol_staff.html');

?>