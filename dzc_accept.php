<?

//ses_req();

audit ("������ ����� ������������ ������ �� ����������� ������������","dzc");
InitRequestVar("wait4myaccept",0);


if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["dzc_accept"]))
	{
		foreach ($_REQUEST["dzc_accept"] as $k=>$v)
		{
			$dzc_accept_exist = $db->getOne('select count(*) from dzc_accept where id='.$k);
			if ($dzc_accept_exist>0)
			{
				Table_Update("dzc_accept",array("id"=>$k),$v);
				$sql=rtrim(file_get_contents('sql/dzc_accept_dzc_head.sql'));
				$params=array(':accept_id' => $k);
				$sql=stritr($sql,$params);
				$h = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			        
				if ($v["accepted"]==1)
				{
			        
					if ($h["dzc_ok"]==1)
					{
						$subj=$h["dpt_name"].". ��������� ������������ ������ �� ����������� ������������ �".$h["id"]." �� ".$h["created"];
					}
					else
					{
						$subj=$h["dpt_name"].". ������������� ������ �� ����������� ������������ �".$h["id"]." �� ".$h["created"];
					}
					audit ("���������� ������ �� ����������� ������������ �".$h["id"],"dzc");
					echo "<font style=\"color: red;\">������ �� ����������� ������������ �".$h["id"]." �� ".$h["created"]." ���� ������������</font>";
					echo "<br><font style=\"color: red;\">�������������� �� ���� ����������:</font><br>";
					if ($h["dzc_ok"]==1)
					{
						$sql=rtrim(file_get_contents('sql/dzc_accept_mail_yes.sql'));
					}
					else
					{
						$sql=rtrim(file_get_contents('sql/dzc_accept_mail_yes_next.sql'));
					}
					$params=array(':accept_id' => $k);
					$sql=stritr($sql,$params);
					$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
					foreach ($data as $k1=>$v1)
					{
						$text=$h["dpt_name"].".<br> ������������ ".$v1["fio"]."<br>".$fio." ����������(�) ������ �� ����������� ������������ �".$h["id"]." ".$now_date_time."<br>";
						if ($h["dzc_ok"]==1)
						{
							$text.="<font style=\"color: green; font-weight:bold\">������������ ������ �� ����������� ������������ ���������</font><br>";
						}
						else
						{
							$text.="����� ������������ ������ ������ �:<br>";
							$sql=rtrim(file_get_contents('sql/dzc_accept_mail_yes_other.sql'));
							$params=array(':accept_id' => $k);
							$sql=stritr($sql,$params);
							$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
							foreach ($data1 as $k2=>$v2)
							{
								$text.=$v2["fio"]."<br>";
							}
						}
						$text.="��� ����������: ".$h["creator"]."<br>"."��������� ����������: ".$h["creator_pos_name"]."<br>"."������������� ����������: ".$h["creator_department_name"]."<br>";
						$text.="<a href='https://ps.avk.ua/?action=dzc_accept'>������</a> �� ������ ����������, ��������� �������������"."<br>";
						$email=$v1["email"];
						echo "<font style=\"color: red;\">".$v1["fio"]."</font>";
						send_mail($email,$subj,$text);
						//send_mail("denis.yakovenko@avk.ua".$email.' '.$subj,$text);
					}
					if ($h["dzc_ok"]==1)
					{
						/* 7. � ������ ���������� ������������ ������ ���������� ��������� � ������ Get ��������� Expences.
						* ��������� ������: Get(codeCustomer, �odeStateOfExpences, codeDepartments, codeProductTypes, codeCurrency, sumExpenses, dateExpenses).
						* dateExpenses - ���������� ���� � ������� "YYYYMM0100000"
						* (������ ����� ����, ��� ����� ������, ��� ����� ��� - 01, ��� ����� ���� - 00, ��� ����� ����� - 00, ��� ����� ������ - 00).
						* �.�. ���������� ������ ����� ������, ������� ������ � ���������� ������. */
						try
						{  
							ini_set("soap.wsdl_cache_enabled", "0");
							$client1s = new SoapClient("http://1cupp.avk.company/Expenses/ws/Expenses/?wsdl");
							$soap_params = array(
								'codeCustomer'=>$h['customerid'],
								'codeStateOfExpences'=>$h['statid'],
								'codeDepartments'=>$h['departmentid'],
								'codeProductTypes'=>$h['producttype'],
								'codeCurrency'=>$h['currencycode'],
								'sumExpenses'=>$h['summa'],
								'dateExpenses'=>$h['dt'].'000000'
								/*
								'codeCustomer'=>1289358871218779886,
								'codeStateOfExpences'=>1289198880368469776,
								'codeDepartments'=>1289277617991902950,
								'codeProductTypes'=>mb_convert_encoding('����','UTF-8','CP1251'),
								'codeCurrency'=>9,
								'sumExpenses'=>123.456,
								'dateExpenses'=>'2015090100000'
								*/
							);
							foreach ($soap_params as $sk => $sv)
							{
								$soap_params[$sk] = mb_convert_encoding($sv,'UTF-8','CP1251');
							}
							//var_dump($soap_params);
							$result = $client1s->Get($soap_params)->return;
							//var_dump(mb_convert_encoding($result,'CP1251','UTF-8'));
							Table_Update("dzc",array("id"=>$h['id']),array("num1s"=>mb_convert_encoding($result,'CP1251','UTF-8')));
						}
						catch (Exception $e)
						{ 
							echo mb_convert_encoding($e->getMessage(),'CP1251','UTF-8');
						}  
					}
				}
				if ($v["accepted"]==2)
				{
					$subj="���������� ������ �� ����������� ������������ �".$h["id"]." �� ".$h["created"];
					audit ("�������� ������ �� ����������� ������������ �".$h["id"],"dzc");
					echo "<font style=\"color: red;\">������ �� ����������� ������������ �".$h["id"]." �� ".$h["created"]." ���� �� ������������</font>";
					echo "<br><font style=\"color: red;\">�������������� �� ���� ����������:</font><br>";
					$sql=rtrim(file_get_contents('sql/dzc_accept_mail_no.sql'));
					$params=array(':accept_id' => $k);
					$sql=stritr($sql,$params);
					//echo $sql;
					$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
					//print_r($data);
					foreach ($data as $k1=>$v1)
					{
						$text=$h["dpt_name"].".<br> ������������ ".$v1["fio"]."<br>".$fio." ��������(�) ������ �� ����������� ������������ �".$h["id"]." ".$now_date_time."<br>
						������� ����������: ".$v["failure"]."<br>";
						$email=$v1["email"];
						echo "<font style=\"color: red;\">".$v1["fio"]."</font>";
						send_mail($email,$subj,$text);
						//send_mail("denis.yakovenko@avk.ua".$email.' '.$subj,$text);
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
	if (isset($_REQUEST["dzc_accept_chat"]))
	{
		foreach ($_REQUEST["dzc_accept_chat"] as $k=>$v)
		{
			if ($v!="")
			{
				Table_Update("dzc_chat",array("tn"=>$tn,"dzc_id"=>$k,"text"=>$v),array("tn"=>$tn,"dzc_id"=>$k,"text"=>$v));
				audit ("������� �� ������ �� ����������� ������������ �".$k." �����������: ".$v,"dzc");
				$sql=rtrim(file_get_contents('sql/dzc_accept_chat.sql'));
				$params=array(':dzc_id' => $k,':tn' => $tn);
				$sql=stritr($sql,$params);
				//echo $sql;
				$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
				//print_r($data);
				foreach ($data as $k1=>$v1)
				{
					$subj="��������� �� ������ �� ����������� ������������ �".$v1["dzc_id"]." �� ".$v1["created"];
					$text="������������ ".$v1["fio"]."<br>";
					$text.="�� ������ �� ����������� ������������ �".$v1["dzc_id"]." �� ".$v1["created"]."<br>";
					$text.=$fio." �������(�) �����������/���������: ".$v."<br>";
					$text.="������� �������� �� �����������/��������� �� ������ ������ �� ����������� ������������ � ������� <a href=\"https://ps.avk.ua/?action=dzc_accept\">������������ ������ �� ����������� ������������</a>";
					$email=$v1["email"];
					send_mail($email,$subj,$text);
					//send_mail("denis.yakovenko@avk.ua".$email.' '.$subj,$text);
				}
			}
		}
	}
}




$sql=rtrim(file_get_contents('sql/accept_types.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('accept_types', $data);

$sql=rtrim(file_get_contents('sql/dzc_accept.sql'));
$params=array(':tn' => $tn, ':wait4myaccept'=>$_REQUEST['wait4myaccept']);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($data as $k=>$v){
$d[$v["id"]]["head"]=$v;
$d[$v["id"]]["data"][$v["acceptor_tn"]]=$v;
if ($v["chat_id"]!="")
{
$d[$v["id"]]["chat"][$v["chat_id"]]=$v;
}
$d[$v["id"]]["files"][$v["fn"]]=$v;
}

isset($d) ? $smarty->assign('d', $d) : null;

//print_r($d);

$smarty->display('dzc_accept.html');

?>