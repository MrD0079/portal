<?
$_REQUEST["tu"]==1?$_REQUEST["st"]=0:InitRequestVar("st",0);
InitRequestVar("wait4myaccept",0);
InitRequestVar("showall",0);
$_REQUEST["tu"]==1?$doc_str="���� �� ����������":$doc_str="������ �� ���������� ����������";

if (isset($_REQUEST["save"]))
{
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
	
				if ($v["accepted"]==1)
				{
					if ($h["bud_ru_zay_ok"]==1)
					{
						// ����� � ��������� ��
						// ����� ���������� ������������ ������ ����������� ������ � ����������� ���� ��������������� ����. 
						$db->query("BEGIN BUD_ZAY2FINPLAN (".$h["id"]."); END;");
						// ��� ������ �� �������� ��������, � ������� � ���� "�� �����" ������ ������������� �������� ������ ����,
						// � ������ ������������ ������ ������������� ������������ ���� ������ ������ �� ������: $(���� ��������� ����������) + $(�� �����) - 1
						$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_set_report_data.sql'));
						$p=array(':id' => $h["id"]);
						$sql=stritr($sql,$p);
						$db->query($sql);
						// After final confirmation of requests check the conditions:
						// - if (���� ������ < ���� ���������� ������������ && category is local action) {
						//    ���� ������ = ���� ���������� ������������;
						//    ���� ��=0 �� ���� ��������� = ���� ������ + �����������������;
						//    ���� ��=1 �� ���� ��������� = ���� ������ + 365 ����
						// }
						$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_set_request_dates.sql'));
						$p=array(':id' => $h["id"]);
						$sql=stritr($sql,$p);
						$db->query($sql);
					}
					if ($h["bud_ru_zay_ok"]==1)
					{
						$subj=$doc_str." �".$h["id"]." �� ".$h["created"].". ��������� ������������";
					}
					else
					{
						$subj=$doc_str." �".$h["id"]." �� ".$h["created"].". �������������";
					}
					echo "<font style=\"color: red;\">".$doc_str." �".$h["id"]." �� ".$h["created"].". ������������ ����.</font>";
					echo "<br><font style=\"color: red;\">�������������� �� ���� ����������:</font><br>";
					if ($h["bud_ru_zay_ok"]==1)
					{
						$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_mail_yes.sql'));
					}
					else
					{
						$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_mail_yes_next.sql'));
					}
					$params=array(':accept_id' => $k);
					$sql=stritr($sql,$params);
					$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
					foreach ($data as $k1=>$v1)
					{
						$text="������������ ".$v1["fio"]."<br>";
						$text.=$doc_str." �".$h["id"].". ".$fio." ����������(�) ".$now_date_time."<br>";
						if ($h["bud_ru_zay_ok"]==1)
						{
							$text.="<font style=\"color: green; font-weight:bold\">".$doc_str." �".$h["id"]." �� ".$h["created"].". ��������� ������������.</font><br>";
						}
						else
						{
							$text.="����� ������������ ������ ������ �:<br>";
							$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_mail_yes_other.sql'));
							$params=array(':accept_id' => $k);
							$sql=stritr($sql,$params);
							$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
							foreach ($data1 as $k2=>$v2)
							{
								$text.=$v2["fio"]."<br>";
							}
						}
						$text.="��� ����������: ".$h["creator"]."<br>"."��������� ����������: ".$h["creator_pos_name"]."<br>"."������������� ����������: ".$h["creator_department_name"]."<br>";
						$text.="<a href='https://ps.avk.ua/?action=bud_ru_zay_accept&tu=".$_REQUEST["tu"]."'>������</a> �� ������ ����������, ��������� �������������"."<br>";
						$email=$v1["email"];
						echo "<font style=\"color: red;\">".$v1["fio"]."</font>";
						send_mail($email,$subj,$text);
					}
					if ($h["bud_ru_zay_ok"]==1)
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
				if ($v["accepted"]==2)
				{
					$subj=$doc_str." �".$h["id"]." �� ".$h["created"].". ����������";
					echo "<font style=\"color: red;\">".$doc_str." �".$h["id"]." �� ".$h["created"].". ���� �� ������������</font>";
					echo "<br><font style=\"color: red;\">�������������� �� ���� ����������:</font><br>";
					$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_mail_no.sql'));
					$params=array(':accept_id' => $k);
					$sql=stritr($sql,$params);
					//echo $sql;
					$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
					//print_r($data);
					foreach ($data as $k1=>$v1)
					{
						$text="������������ ".$v1["fio"]."<br>";
						$text.=$doc_str." �".$h["id"].". ".$fio." ��������(�) ".$now_date_time."<br>";
						$text.="������� ����������: ".$v["failure"]."<br>";
						$email=$v1["email"];
						echo "<font style=\"color: red;\">".$v1["fio"]."</font>";
						send_mail($email,$subj,$text);
					}
                    //add chat with rejection detail
                    if(isset($_REQUEST['bud_ru_zay_failure_id'][$k])){
                        $keys_reject = array(
                            "tn"=>$tn,
                            "z_id"=>$_REQUEST['bud_ru_zay_failure_id'][$k],
                            "text"=>"���������: ".$v["failure"]);
                        Table_Update("bud_ru_zay_chat",$keys_reject,$keys_reject);
                    }
				}
				if ($v["accepted"]!=0)
				{
					echo "<hr>";
				}
			}
		}
	}
}


if (isset($_REQUEST["add_chat"]))
{
	if (isset($_REQUEST["bud_ru_zay_accept_chat"]))
	{
		foreach ($_REQUEST["bud_ru_zay_accept_chat"] as $k=>$v)
		{
			if ($v!="")
			{
				Table_Update("bud_ru_zay_chat",array("tn"=>$tn,"z_id"=>$k,"text"=>$v),array("tn"=>$tn,"z_id"=>$k,"text"=>$v));
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
					$text.="������� �������� �� �����������/��������� <a href=\"https://ps.avk.ua/?action=bud_ru_zay_accept&tu=".$_REQUEST["tu"]."\">�����</a>";
					$email=$v1["email"];
					send_mail($email,$subj,$text);
				}
			}
		}
	}
}

$sql=rtrim(file_get_contents('sql/bud_ru_st_ras.sql'));
$params=array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$st = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('st', $st);

$sql=rtrim(file_get_contents('sql/accept_types.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('accept_types', $data);

$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept.sql'));
$params=array(
	':tn' => $tn,
	':wait4myaccept'=>$_REQUEST['wait4myaccept'],
	':tu'=>$_REQUEST['tu'],
	':st'=>$_REQUEST["st"],
);
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
}
if (isset($d))
{
    if ($_REQUEST["showall"]==0)
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
            $smarty->assign('tooManyLines',
                '<p style="color:red">���������� �� ��� ���������, '.$max.' �� '.$i.'.<br>'.
                '��������� ��������� ����� ���������� ����� ������������ ������������.<br>'.
                '<a href="?action=bud_ru_zay_accept&tu=1&showall=1">�������� ��� ���������</a></p>');
        }
    }
    foreach ($d as $k=>$v)
    {
            $sql=rtrim(file_get_contents('sql/bud_ru_zay_get_ff.sql'));
            $params=array(':z_id' => $k);
            $sql=stritr($sql,$params);
            $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            foreach ($data as $k1=>$v1)
            {
                    if ($v1["type"]=="file")
                    {
                            $data[$k1]["val_file"]=explode("\n",$v1["val_file"]);
                    }
                    /*if ($v1['type']=='list')
                    {
                            $sql=$db->getOne('SELECT get_item FROM bud_ru_ff_subtypes WHERE id = (SELECT subtype FROM bud_ru_ff WHERE id = '.$v1['ff_id'].')');
                            $params[':id'] = $v1['val_list'];
                            $sql=stritr($sql,$params);
                            $list = $db->getOne($sql);
                            $data[$k1]['val_list_name'] = $list;
                    }*/
            }
            include "bud_ru_zay_formula.php";
            $d[$k]["ff"]=$data;
    }
}
isset($d) ? $smarty->assign('d', $d) : null;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_total.sql'));
$params=array(
	':tn' => $tn,
	':wait4myaccept'=>$_REQUEST['wait4myaccept'],
	':tu'=>$_REQUEST['tu'],
	':st'=>$_REQUEST["st"],
);
$sql=stritr($sql,$params);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d1', $data);

include "SkuSelect.php";
$skuObj = new \SkuSelect\SkuSelect($db);
$smarty->assign('skuObj', $skuObj);

$smarty->display('bud_ru_zay_accept.html');
?>