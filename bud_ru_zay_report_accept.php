<?
InitRequestVar("st",0);
InitRequestVar("wait4myaccept",1);
$_REQUEST["tu"]==1?$doc_str="�������� �������":$doc_str="����� �� ������ �� ���������� ����������";

$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);

$sql=rtrim(file_get_contents('sql/bud_ru_st_ras.sql'));
$sql=stritr($sql,$params);
$st = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('st', $st);

$sql=rtrim(file_get_contents('sql/accept_types.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('accept_types', $data);

if (isset($_REQUEST["save"]))
{
	
	$_REQUEST["select"]=1;
	if (isset($_REQUEST["report_done"]))
	{
		foreach ($_REQUEST["report_done"] as $k=>$v)
		{
			$keys = array("id"=>$k);
			$vals = array("report_done"=>$v);
			Table_Update("bud_ru_zay",$keys,$vals);
		}
	}
	if (isset($_REQUEST["new_st"]))
	{
		foreach ($_REQUEST["new_st"] as $k=>$v)
		{
			$var_type = $db->getOne("SELECT TYPE FROM bud_ru_ff WHERE id = (SELECT ff_id FROM bud_ru_zay_ff WHERE id = ".$k.")");
			$var_type=="datepicker"&&isset($v) ? $v=OraDate2MDBDate($_REQUEST["new_st"][$k]) : null;
			$var_type=="file"&&isset($v) ? $v=implode($v,"\n") : null;
			$keys = array("id"=>$k);
			$vals = array("rep_val_".$var_type=>$v);
			Table_Update("bud_ru_zay_ff",$keys,$vals);
		}
	}

	if (isset($_REQUEST["bud_ru_zay_files_del"]))
	{
		foreach ($_REQUEST["bud_ru_zay_files_del"] as $k=>$v)
		{
			$id=$db->getOne("select z_id from bud_ru_zay_ff where id=".$k);
			$old_val=$db->getOne("select rep_val_file from bud_ru_zay_ff where id=".$k);
			$ov=explode("\n",$old_val);
			$keys = array("id"=>$k);
			$del_array=array();
			foreach ($v as $k1=>$v1)
			{
				unlink($v1);
				$del_array[]=$k1;
		}
			$vals = array("rep_val_file"=>implode(array_diff($ov,$del_array),"\n"));
			Table_Update("bud_ru_zay_ff",$keys,$vals);
		}
	}

	if (isset($_FILES["new_st"]))
	{
		foreach ($_FILES["new_st"]["tmp_name"] as $k=>$v)
		{
			$id=$db->getOne("select z_id from bud_ru_zay_ff where id=".$k);
			$ff_id=$db->getOne("select ff_id from bud_ru_zay_ff where id=".$k);
			$old_val=$db->getOne("select rep_val_file from bud_ru_zay_ff where id=".$k);
			isset($old_val)?$old_val="\n".$old_val:null;
			$s=array();
			foreach ($v as $k1=>$v1)
			{
			if (is_uploaded_file($v1))
			{
				$a=pathinfo($_FILES["new_st"]["name"][$k][$k1]);
				$fn=translit($_FILES["new_st"]["name"][$k][$k1]);
				$path="files/bud_ru_zay_files/".$id."/".$ff_id."/report";
				if (!file_exists($path)) {mkdir($path,0777,true);}
				move_uploaded_file($v1, $path."/".$fn);
				$s[]=$fn;
				$ss=implode($s,"\n");
				$keys = array("id"=>$k);
				$vals = array("rep_val_file"=>$ss.$old_val);
				Table_Update("bud_ru_zay_ff",$keys,$vals);
			}
			}
		}
	}


	if (isset($_REQUEST["sup_doc_del"]))
	{
		foreach ($_REQUEST["sup_doc_del"] as $k=>$v)
		{
			$old_val=$db->getOne("select sup_doc from bud_ru_zay where id=".$k);
			$ov=explode("\n",$old_val);
			$keys = array("id"=>$k);
			$del_array=array();
			foreach ($v as $k1=>$v1)
			{
				unlink($v1);
				$del_array[]=$k1;
			}
			$vals = array("sup_doc"=>implode(array_diff($ov,$del_array),"\n"));
			Table_Update("bud_ru_zay",$keys,$vals);
		}
	}

	if (isset($_FILES["sup_doc"]))
	{
		foreach ($_FILES["sup_doc"]["tmp_name"] as $k=>$v)
		{
			$old_val=$db->getOne("select sup_doc from bud_ru_zay where id=".$k);
			isset($old_val)?$old_val="\n".$old_val:null;
			$s=array();
			foreach ($v as $k1=>$v1)
			{
			if (is_uploaded_file($v1))
			{
				$a=pathinfo($_FILES["sup_doc"]["name"][$k][$k1]);
				$fn=translit($_FILES["sup_doc"]["name"][$k][$k1]);
				$path="files/bud_ru_zay_files/".$k."/sup_doc";
				if (!file_exists($path)) {mkdir($path,0777,true);}
				move_uploaded_file($v1, $path."/".$fn);
				$s[]=$fn;
				$ss=implode($s,"\n");
				$keys = array("id"=>$k);
				$vals = array("sup_doc"=>$ss.$old_val);
				Table_Update("bud_ru_zay",$keys,$vals);
			}
			}
		}
	}

	if (isset($_REQUEST["bud_ru_zay_accept"]))
	{
		foreach ($_REQUEST["bud_ru_zay_accept"] as $k=>$v)
		{
			$cnt = $db->getOne('select count(*) from bud_ru_zay_accept where id='.$k);
			if ($cnt==1)
			{
				Table_Update("bud_ru_zay_accept",array("id"=>$k),$v);
				$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_bud_ru_zay_head.sql'));
				$params=array(':accept_id' => $k);
				$sql=stritr($sql,$params);
				$h = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
						
				$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_executors.sql'));
				$params=array(':accept_id' => $k);
				$sql=stritr($sql,$params);
				$e = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	
				if ($v["rep_accepted"]==1)
				{
	
					if ($h["rep_bud_ru_zay_ok"]==1)
					{
						// ����� � ��������� ��
                                                // �������������� � bud_ru_zay_report.php
						// ����� ���������� ������������ ������ �� ������ ����������� ������ � ���� ��������� ����� ��������������� ����. 
						$db->query("BEGIN BUD_ZAY_REP2FINPLAN (".$h["id"]."); END;");
                                                // ���� "����� ��������� ������" ����������� ����� ����� �� ���������� ���������� ����� "���������������" ������. 
                                                $db->query("BEGIN set_cost_assign_month (".$h["id"]."); END;");
                                                
					}
					if ($h["rep_bud_ru_zay_ok"]==1)
					{
						$subj=$doc_str." �".$h["id"]." �� ".$h["created"].". ��������� ������������";
					}
					else
					{
						$subj=$doc_str." �".$h["id"]." �� ".$h["created"].". �������������";
					}
					echo "<font style=\"color: red;\">".$doc_str." �".$h["id"]." �� ".$h["created"].". ������������ ����.</font>";
					echo "<br><font style=\"color: red;\">�������������� �� ���� ����������:</font><br>";
					if ($h["rep_bud_ru_zay_ok"]==1)
					{
						$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_mail_rep_yes.sql'));
					}
					else
					{
						$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_mail_rep_yes_next.sql'));
					}
					$params=array(':accept_id' => $k);
					$sql=stritr($sql,$params);
					$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
					foreach ($data as $k1=>$v1)
					{
						$text="������������ ".$v1["fio"]."<br>";
						$text.=$doc_str." �".$h["id"].". ".$fio." ����������(�) ".$now_date_time."<br>";
						if ($h["rep_bud_ru_zay_ok"]==1)
						{
							$text.="<font style=\"color: green; font-weight:bold\">".$doc_str." �".$h["id"]." �� ".$h["created"].". ��������� ������������.</font><br>";
						}
						else
						{
							$text.="����� ������������ ������ ������ �:<br>";
							$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_mail_rep_yes_other.sql'));
							$params=array(':accept_id' => $k);
							$sql=stritr($sql,$params);
							$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
							foreach ($data1 as $k2=>$v2)
							{
								$text.=$v2["fio"]."<br>";
							}
						}
						$email=$v1["email"];
						echo "<font style=\"color: red;\">".$v1["fio"]."</font>";
						send_mail($email,$subj,$text);
					}
					if ($h["rep_bud_ru_zay_ok"]==1)
					{
						if (count($e)>0)
						{
							$text=$doc_str." �".$h["id"]." �� ".$h["created"].". �� ��������� ������������";
							foreach ($e as $k2=>$v2)
							{
								$email=$v2["e_mail"];
								send_mail($email,$subj,$text,$fn);
							}
						}
					}
				}
				if ($v["rep_accepted"]==2)
				{
					$subj=$doc_str." �".$h["id"]." �� ".$h["created"].". ����������";
					echo "<font style=\"color: red;\">".$doc_str." �".$h["id"]." �� ".$h["created"].". ���� �� ������������</font>";
					echo "<br><font style=\"color: red;\">�������������� �� ���� ����������:</font><br>";
					$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_mail_rep_no.sql'));
					$params=array(':accept_id' => $k);
					$sql=stritr($sql,$params);
					//echo $sql;
					$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
					//print_r($data);
					foreach ($data as $k1=>$v1)
					{
						$text="������������ ".$v1["fio"]."<br>";
						$text.=$doc_str." �".$h["id"].". ".$fio." ��������(�) ".$now_date_time."<br>";
						$text.="������� ����������: ".$v["rep_failure"]."<br>";
						$email=$v1["email"];
						echo "<font style=\"color: red;\">".$v1["fio"]."</font>";
						send_mail($email,$subj,$text);
					}

				}
				if ($v["rep_accepted"]!=0)
				{
					echo "<hr>";
				}
			}
		}
	}
}


if (isset($_REQUEST["add_chat"]))
{
	
	$_REQUEST["select"]=1;
	if (isset($_REQUEST["bud_ru_zay_accept_chat"]))
	{
		foreach ($_REQUEST["bud_ru_zay_accept_chat"] as $k=>$v)
		{
			if ($v!="")
			{
				Table_Update("bud_ru_zay_rep_chat",array("tn"=>$tn,"z_id"=>$k,"text"=>$v),array("tn"=>$tn,"z_id"=>$k,"text"=>$v));
				$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_chat.sql'));
				$params=array(':z_id' => $k,':tn' => $tn);
				$sql=stritr($sql,$params);
				$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
				foreach ($data as $k1=>$v1)
				{
					$subj=$doc_str." �".$v1["z_id"]." �� ".$v1["created"].". ���������";
					$text="������������ ".$v1["fio"]."<br>";
					$text.=$doc_str." �".$v1["z_id"]." �� ".$v1["created"]."<br>";
					$text.=$fio." �������(�) �����������/���������: ".$v."<br>";
					$text.="������� �������� �� �����������/��������� <a href=\"https://ps.avk.ua/?action=bud_ru_zay_report_accept&tu=".$_REQUEST["tu"]."\">�����</a>";
					$email=$v1["email"];
					send_mail($email,$subj,$text);
				}
			}
		}
	}
}

$params=array(
	':tn' => $tn,
	':wait4myaccept'=>$_REQUEST['wait4myaccept'],
	':tu'=>$_REQUEST['tu'],
	':st'=>$_REQUEST["st"],
);

$sql=rtrim(file_get_contents('sql/bud_ru_zay_report_accept.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($data as $k=>$v)
{
	$d[$v["id"]]["head"]=$v;
	$d[$v["id"]]["executors"][$v["executor_tn"]]=$v;
	$d[$v["id"]]["data"][$v["acceptor_tn"]]=$v;
	if ($v["chat_id"]!="")
	{
		$d[$v["id"]]["chat"][$v["chat_id"]]=$v;
	}
	if ($v["zchat_id"]!="")
	{
		$d[$v["id"]]["zchat"][$v["zchat_id"]]=$v;
	}
}
if (isset($d))
{

$max=100;
$i=0;
foreach ($d as $k=>$v)
{
	$i++;
	if ($i>$max) {
		unset($d[$k]);
	}
}
if ($i>$max){
	$smarty->assign('tooManyLines','<p style="color:red">���������� �� ��� ���������, '.$max.' �� '.$i.'. ��������� ��������� ����� ���������� ����� ������������ ������������.</p>');
}

foreach ($d as $k=>$v)
{
	$sql=rtrim(file_get_contents('sql/bud_ru_zay_get_ff.sql'));
	$p=array(':z_id' => $k);
	$sql=stritr($sql,$p);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($data as $k1=>$v1)
	{
		if ($v1["type"]=="file")
		{
			$v1["val_file"]!=null?$data[$k1]["val_file"]=explode("\n",$v1["val_file"]):null;
			$v1["rep_val_file"]!=null?$data[$k1]["rep_val_file"]=explode("\n",$v1["rep_val_file"]):null;
		}
		/*if ($v1['type']=='list')
		{
			$sql=$db->getOne('SELECT get_item FROM bud_ru_ff_subtypes WHERE id = (SELECT subtype FROM bud_ru_ff WHERE id = '.$v1['ff_id'].')');
			$params[':id'] = $v1['val_list'];
			$sql=stritr($sql,$params);
			$list = $db->getOne($sql);
			$data[$k1]['val_list_name'] = $list;

			$sql=$db->getOne('SELECT get_item FROM bud_ru_ff_subtypes WHERE id = (SELECT subtype FROM bud_ru_ff WHERE id = '.$v1['ff_id'].')');
			$params[':id'] = $v1['rep_val_list'];
			$sql=stritr($sql,$params);
			$list = $db->getOne($sql);
			$data[$k1]['rep_val_list_name'] = $list;
		}*/
	}
	include "bud_ru_zay_formula.php";
	$d[$k]["ff"]=$data;
	$v["head"]["sup_doc"]!=null?$d[$k]["head"]["sup_doc"]=explode("\n",$v["head"]["sup_doc"]):null;
}
}

//print_r($d);
//print_r($params);

isset($d) ? $smarty->assign('d', $d) : null;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_report_accept_total.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d1', $data);

$smarty->display('bud_ru_zay_report_accept.html');

?>