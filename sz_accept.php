<?



//audit ("������ ����� ������������ ��","sz");
InitRequestVar("wait4myaccept",0);

if (strpos($parameters["ShowHighPriorityCheckBoxInMemos"]["val_string"], (string)$tn)!==false)
{
    $smarty->assign('ShowHighPriorityCheckBoxInMemos', 1);
}

if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["sz_accept"]))
	{
		foreach ($_REQUEST["sz_accept"] as $k=>$v)
		{
			$cnt = $db->getOne('select count(*) from sz_accept where id='.$k);
			$already_accepted = $db->getOne('select count(*) from sz_accept where id='.$k.' AND accepted IN (1, 2)');
			if ($cnt==1&&$already_accepted==0)
			{
                                Table_Update("sz_accept",array("id"=>$k),$v);
				$sql=rtrim(file_get_contents('sql/sz_accept_sz_head.sql'));
				$params=array(':accept_id' => $k);
				$sql=stritr($sql,$params);
				$h = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			        
				$sql=rtrim(file_get_contents('sql/sz_accept_sz_executors.sql'));
				$params=array(':accept_id' => $k);
				$sql=stritr($sql,$params);
				$e = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			        
				if ($v["accepted"]==1)
				{
			        
					if ($h["sz_ok"]==1)
					{
						$subj=$h["dpt_name"].". ��������� ������������ �� �".$h["id"]." �� ����: ".$h["head"]." �� ".$h["created"];
					}
					else
					{
						$subj=$h["dpt_name"].". ������������� �� �".$h["id"]." �� ����: ".$h["head"]." �� ".$h["created"];
					}
					audit ("���������� �� �".$h["id"],"sz");
					echo "<font style=\"color: red;\">�� �".$h["id"]." �� ����: ".$h["head"]." �� ".$h["created"]." ���� ������������</font>";
					echo "<br><font style=\"color: red;\">�������������� �� ���� ����������:</font><br>";
					if ($h["sz_ok"]==1)
					{
						$sql=rtrim(file_get_contents('sql/sz_accept_mail_yes.sql'));
					}
					else
					{
						$sql=rtrim(file_get_contents('sql/sz_accept_mail_yes_next.sql'));
					}
					$params=array(':accept_id' => $k);
					$sql=stritr($sql,$params);
					$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
					foreach ($data as $k1=>$v1)
					{
						$text=$h["dpt_name"].".<br> ������������ ".$v1["fio"]."<br>".$fio." ����������(�) �� �".$h["id"]." ".$now_date_time."<br>";
						if ($h["sz_ok"]==1)
						{
							$text.="<font style=\"color: green; font-weight:bold\">������������ ��������� ������� ���������</font><br>";
						}
						else
						{
							$text.="����� ������������ ������ ������ �:<br>";
							$sql=rtrim(file_get_contents('sql/sz_accept_mail_yes_other.sql'));
							$params=array(':accept_id' => $k);
							$sql=stritr($sql,$params);
							$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
							foreach ($data1 as $k2=>$v2)
							{
								$text.=$v2["fio"]."<br>";
							}
						}
						$text.="��� ����������: ".$h["creator"]."<br>"."��������� ����������: ".$h["creator_pos_name"]."<br>"."������������� ����������: ".$h["creator_department_name"]."<br>";
						$text.="<a href='https://ps.avk.ua/?action=sz_accept'>������</a> �� ������ ����������, ��������� �������������"."<br>";
						$email=$v1["email"];
						echo "<font style=\"color: red;\">".$v1["fio"]."</font>";
						send_mail($email,$subj,$text);
					}
					if ($h["sz_ok"]==1)
					{
						//$subj="��������� ������������ �� �".$h["id"]." �� ����: ".$h["head"]." �� ".$h["created"];
						if (count($e)>0)
						{
							$text=$h["dpt_name"].".<br> �� ��������� ������������ �� �� �".$h["id"]." �� ���� ".$h["head"]." �� ".$h["created"]."<br>";
							$text.="<b>".nl2br($h["body"])."</b><br>";
							$text.="����������� ������ �� ��������(�) ".$h["creator"]."<br>";
							$text.="����������� �� ��:<br>";
							$sql=rtrim(file_get_contents('sql/sz_accept_sz_ok_chat.sql'));
							$params=array(':sz_id' => $h["id"]);
							$sql=stritr($sql,$params);
							$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
							foreach ($data1 as $k2=>$v2)
							{
								$text.=$v2["lu"]." ".$v2["fio"].": ".$v2["text"]."<br>";
							}
							if (count($e)>1)
							{
								$text.="������������� �� ������ �� ���������: <br/>";
								foreach ($e as $k2=>$v2)
								{
									$text.=$v2["fio"]." - ".$v2["e_mail"]."<br/>";
								}
							}
                                                        $text.="<a href='https://ps.avk.ua/?action=sz_reestr&sz_id=".$h["id"]."&select=1'>������</a> �� �������� � ������� ����������"."<br>";
							$r = file_get_contents("https://ps.avk.ua/sz_view.php?id=".$h["id"]."&print=1&pdf=1&to_file=1");
							$fn=array("files/attach".$h["id"].".pdf");
							$sql=rtrim(file_get_contents('sql/sz_files.sql'));
							$params=array(':id'=>$h["id"]);
							$sql=stritr($sql,$params);
							$data = $db->getAssoc($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
							foreach ($data as $k3=>$v3)
							{
								$fn[]="files/".$v3["fn"];
							}
							foreach ($e as $k2=>$v2)
							{
								$email=$v2["e_mail"];
								send_mail($email,$subj,$text,$fn);
							}
						}
						if ($h["cat"]==927679)
						{
							$db->query("BEGIN PR_VACATION_SZ_OK (".$h["id"]."); END;");
						}
						if ($h["cat"]==927672)
						{
//							$db->query("BEGIN PR_BONUS_SZ_OK (".$h["id"]."); END;");
							$db->query("BEGIN PR_BONUS_NEW_OK (".$h["id"]."); END;"); //create from persik.sz
						}
					}
				}
				if ($v["accepted"]==2)
				{
					$subj="���������� �� �".$h["id"]." �� ����: ".$h["head"]." �� ".$h["created"];
					audit ("�������� �� �".$h["id"],"sz");
					echo "<font style=\"color: red;\">�� �".$h["id"]." �� ����: ".$h["head"]." �� ".$h["created"]." ���� �� ������������</font>";
					echo "<br><font style=\"color: red;\">�������������� �� ���� ����������:</font><br>";
					$sql=rtrim(file_get_contents('sql/sz_accept_mail_no.sql'));
					$params=array(':accept_id' => $k);
					$sql=stritr($sql,$params);
					//echo $sql;
					$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
					//print_r($data);
					foreach ($data as $k1=>$v1)
					{
						$text=$h["dpt_name"].".<br> ������������ ".$v1["fio"]."<br>".$fio." ��������(�) �� �".$h["id"]." ".$now_date_time."<br>������� ����������: ".$v["failure"]."<br>";
						$email=$v1["email"];
						echo "<font style=\"color: red;\">".$v1["fio"]."</font>";
						send_mail($email,$subj,$text);
					}
					//add chat with rejection detail
                    if(isset($_REQUEST['sz_failed_id'][$k])){
                        $keys_reject = array(
                            "tn"=>$tn,
                            "sz_id"=>$_REQUEST['sz_failed_id'][$k],
                            "text"=>"���������: ".$v["failure"]);
                        Table_Update("sz_chat",$keys_reject,$keys_reject);
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
	if (isset($_REQUEST["sz_accept_chat"]))
	{
		foreach ($_REQUEST["sz_accept_chat"] as $k=>$v)
		{
			if ($v!="")
			{
                            $keys=array("tn"=>$tn,"sz_id"=>$k,"text"=>$v);
                            if (isset($_REQUEST["sz_accept_chat_high_priority"][$k]))
                                $keys["priority"]=1;
                            Table_Update("sz_chat",$keys,$keys);
                            audit ("������� �� �� �".$k." �����������: ".$v,"sz");
                            $sql=rtrim(file_get_contents('sql/sz_accept_chat.sql'));
                            $params=array(':sz_id' => $k,':tn' => $tn);
                            $sql=stritr($sql,$params);
                            //echo $sql;
                            $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
                            //print_r($data);
                            foreach ($data as $k1=>$v1)
                            {
                                $subj="��������� �� �� �".$v1["sz_id"]." �� ����: ".$v1["head"]." �� ".$v1["created"];
                                $text="������������ ".$v1["fio"]."<br>";
                                $text.="�� �� �".$v1["sz_id"]." �� ����: ".$v1["head"]." �� ".$v1["created"]."<br>";
                                $text.=$fio." �������(�) �����������/���������: ".$v."<br>";
                                $text.="������� �������� �� �����������/��������� �� ������ �� � ������� <a href=\"https://ps.avk.ua/?action=sz_accept\">������������ ��</a>";
                                $email=$v1["email"];
                                send_mail($email,$subj,$text);
                            }
			}
		}
	}
}




$sql=rtrim(file_get_contents('sql/accept_types.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('accept_types', $data);

$sql=rtrim(file_get_contents('sql/sz_accept.sql'));
$params=array(':tn' => $tn, ":sz_cat"=>0,':wait4myaccept'=>$_REQUEST['wait4myaccept']);
$sql=stritr($sql,$params);
//$_REQUEST["sql"]=$sql;

//echo $sql;
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($data as $k=>$v){
    $d[$v["id"]]["head"]=$v;
    $d[$v["id"]]["executors"][$v["executor_tn"]]=$v;
    $d[$v["id"]]["data"][$v["acceptor_tn"]]=$v;
    if ($v["chat_id"]!="")
    {
        $d[$v["id"]]["chat"][$v["chat_id"]]=$v;
    }
    $d[$v["id"]]["files"][$v["fn"]]=$v;
}

isset($d) ? $smarty->assign('d', $d) : null;

//print_r($d);

$smarty->display('sz_accept.html');

?>