<?
if (isset($_REQUEST["free"])&&isset($_REQUEST["free_staff"]))
{
	$pers1=$parameters["pers1"]["val_string"];
	$pers2=$parameters["pers2"]["val_string"];
	$accept1=$parameters["accept1"]["val_string"];
	$accept2=$parameters["accept2"]["val_string"];
	$it1=$parameters["it1"]["val_string"];
	$it2=$parameters["it2"]["val_string"];

	foreach ($_REQUEST["free_staff"] as $k=>$v)
	{
		$datauvol=$v["datauvol"];
		$block_email=$v["block_email"];
		$block_mob=$v["block_mob"];
		$block_portal=$v["block_portal"];

		$v["datauvol"]=OraDate2MDBDate($v["datauvol"]);
		$v["block_email"]=OraDate2MDBDate($v["block_email"]);
		$v["block_mob"]=OraDate2MDBDate($v["block_mob"]);
		$v["block_portal"]=OraDate2MDBDate($v["block_portal"]);
		Table_Update("free_staff",array("id"=>$k),$v);

		$email_creator=$db->getOne("select e_mail from user_list where tn=(select creator from free_staff where id=".$k.")");
		$fio_creator=$db->getOne("select fio from user_list where tn=(select creator from free_staff where id=".$k.")");
		$fio_staff=$db->getOne("select fio from user_list where tn=(select tn from free_staff where id=".$k.")");
		$dpt_staff=$db->getOne("select dpt_name from user_list where tn=(select tn from free_staff where id=".$k.")");
		$email_staff=$db->getOne("select e_mail from user_list where tn=(select tn from free_staff where id=".$k.")");
		$free_tn=$db->getOne("select tn from free_staff where id=".$k);
		$seat=$db->getOne("select name from free_staff_seat where id=(select seat from free_staff where id=".$k.")");

		isset($_REQUEST["r"]) ? $r=$_REQUEST["r"]: $r=array();
		isset($_REQUEST["comment"]) ? $comment=$_REQUEST["comment"]: $comment=array();
		if (isset($r[$k]))
		{
			$v["sz_id"]!=''?$sz="�ǹ: ".$v["sz_id"]."<br>":$sz="";
			if ($r[$k]==0)
			{
				$subj=$dpt_staff.". ������ �� ���������� ���������� ".$fio_staff;
				$text="������������.<br>";
				$text.="������ �� ���������� ���������� ".$fio_staff." ���������.<br>";
				$text.="��� ������� � ���������� / ��������������� �������� ���� ������.<br>";
				$text.="��� ������������� ����������� ��������� ���������� ��� ���������� ������ ��������� ������ � ���������� ��������� ���� ����������� ����������.<br>";
				$text.="������: ".$_SESSION["cnt_name"]."<br>";
				$text.=$sz;
				$comment[$k]!=''?$text.="�����������: <b>".$comment[$k]."</b><br>":null;
				send_mail($email_creator,$subj,$text,null);
				Table_Update("free_staff",array("id"=>$k),null);

			}
			if ($r[$k]==1)
			{
				$subj=$dpt_staff.". ���������� ���������� ".$fio_staff;
        
				$text="������������.<br>";
				$text.="������������, ������ �� ���������� ���������� ".$fio_staff." ��������� � �����������.<br>������ ������ ��������� ���������� ���, � ����� ������ � ��-������������.<br>".$sz;
				$text.="������: ".$_SESSION["cnt_name"]."<br>";
				send_mail($email_creator,$subj,$text,null);
        
				$text="������������.<br>";
				$text.="� ".$datauvol." ����������� ��������� ".$fio_staff." ������������ ".$fio_creator.".<br>������� ���������� - ".$seat.".<br>������� ����������: ".$v["params"].".<br>������� ������ ����������� ��������� � ���� ��������<br>".$sz;
				$text.="������: ".$_SESSION["cnt_name"]."<br>";
				send_mail($pers1,$subj,$text,null);
				send_mail($pers2,$subj,$text,null);
        
				$text="������������.<br>";
				$text.="� ".$datauvol." ����������� ��������� ".$fio_staff." ������������ ".$fio_creator.".<br>������� ���������� - ".$seat.".<br>������� ����������: ".$v["params"].".<br>������� ������ ������ ���������� ��� ������������� ������<br>".$sz;
				$text.="������: ".$_SESSION["cnt_name"]."<br>";
				send_mail($accept1,$subj,$text,null);
				send_mail($accept2,$subj,$text,null);
        
        
				$text="������������.<br>";
				$text.="� ".$datauvol." ����������� ��������� ".$fio_staff." ������������ ".$fio_creator.".<br>������� ���������� - ".$seat.".<br>������� ����������: ".$v["params"].".<br>������� ���������� ������ �������������� ���������� ������ � ���-������� � ".$block_mob."<br>".$sz;
				$text.="������: ".$_SESSION["cnt_name"]."<br>";
				send_mail($it1,$subj,$text,null);
        
				$text="������������.<br>";
				$text.="� ".$datauvol." ����������� ��������� ".$fio_staff." ������������ ".$fio_creator.".<br>������� ���������� - ".$seat.".<br>������� ����������: ".$v["params"].".<br>������� ������������� ������������� ����������� ����� ".$email_staff." � ".$block_email."<br>".$sz;
				$text.="������: ".$_SESSION["cnt_name"]."<br>";
				send_mail($it2,$subj,$text,null);

				audit("������ ��� ".$free_tn." �������� � ����� � �����������","free_staff_accept");

				Table_Update("free_staff",array("id"=>$k),array("accepted"=>1));
			}
		}
	}
}

$p = array(':dpt_id' => $_SESSION["dpt_id"]);

$sql=rtrim(file_get_contents('sql/free_staff.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($data as $k=>$v)
{
    $p = array(':tn' => $v["creator"]);
    $sql=rtrim(file_get_contents('sql/free_staff_childs.sql'));
    $sql=stritr($sql,$p);
    //echo $sql."<br>";
    $data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $data[$k]['childs']=$data1;

    $sql=rtrim(file_get_contents('sql/free_staff_my_emp_all.sql'));
    $p = array(':tn' => $v["creator"]);
    $sql=stritr($sql,$p);
    $data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $data[$k]['my_emp_all']=$data1;
}

$smarty->assign('free_staff', $data);


$sql=rtrim(file_get_contents('sql/free_staff_seat.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('seat', $data);

$smarty->display('free_staff_accept.html');

?>