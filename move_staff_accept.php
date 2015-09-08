<?
if (isset($_REQUEST["move"])&&isset($_REQUEST["move_staff"]))
{
	$pers1=$parameters["pers1"]["val_string"];
	$pers2=$parameters["pers2"]["val_string"];
	$accept1=$parameters["accept1"]["val_string"];
	$accept2=$parameters["accept2"]["val_string"];
	$it1=$parameters["it1"]["val_string"];
	$it2=$parameters["it2"]["val_string"];

	foreach ($_REQUEST["move_staff"] as $k=>$v)
	{
		$datamove=$v["datamove"];
		$v["datamove"]=OraDate2MDBDate($v["datamove"]);
		Table_Update("move_staff",array("id"=>$k),$v);
	}

	if (isset($_REQUEST["move_staff_detail"]))
	{
		foreach ($_REQUEST["move_staff_detail"] as $k=>$v)
		{
			if (isset($v["bud_fil"]))
			{
				foreach ($v["bud_fil"] as $k1=>$v1)
				{
					//Table_Update("new_staff_bud_fil",array("id"=>$k1),$v):null;
					$keys = array('parent'=>$k,'fil'=>$k1);
					$vals = array('fil'=>$k1);
					($v1=='')?$vals=null:null;
					Table_Update("move_staff_bud_fil",$keys,$vals);
				}
			}
		}
	}

	foreach ($_REQUEST["move_staff"] as $k=>$v)
	{
		$datamove=$v["datamove"];
		$v["datamove"]=OraDate2MDBDate($v["datamove"]);
		//Table_Update("move_staff",array("id"=>$k),$v);

		$email_creator=$db->getOne("select e_mail from user_list where tn=(select creator from move_staff where id=".$k.")");
		$fio_creator=$db->getOne("select fio from user_list where tn=(select creator from move_staff where id=".$k.")");
		$fio_staff=$db->getOne("select fio from user_list where tn=(select tn from move_staff where id=".$k.")");
		$dpt_staff=$db->getOne("select dpt_name from user_list where tn=(select tn from move_staff where id=".$k.")");
		$email_staff=$db->getOne("select e_mail from user_list where tn=(select tn from move_staff where id=".$k.")");
		$move_tn=$db->getOne("select tn from move_staff where id=".$k);

		isset($_REQUEST["r"]) ? $r=$_REQUEST["r"]: $r=array();
		isset($_REQUEST["comment"]) ? $comment=$_REQUEST["comment"]: $comment=array();
		if (isset($r[$k]))
		{
			if ($r[$k]==0)
			{
				$subj=$dpt_staff.". Запрос на перевод сотрудника";
				$text="Здравствуйте.<br>";
				$text.="Заявка на перевод сотрудника ".$fio_staff." отклонена.<br>";
				$text.="Это связано с неполнотой / некорректностью поданных Вами данных.<br>";
				$text.="Для осуществления технической процедуры увольнения Вам необходимо заново заполнить заявку с корректным указанием всей необходимой информации.<br>";
				$text.="Страна: ".$_SESSION["cnt_name"]."<br>";
				$comment[$k]!=''?$text.="Комментарий: <b>".$comment[$k]."</b><br>":null;
				send_mail($email_creator,$subj,$text,null);

				Table_Update("move_staff",array("id"=>$k),null);

			}
			if ($r[$k]==1)
			{

				$subj=$dpt_staff.". перевод сотрудника";
				$text="Здравствуйте.<br>";
				$text.="Здравствуйте, запрос на перевод сотрудника ".$fio_staff." обработан и подтвержден.<br>";
				$text.="Страна: ".$_SESSION["cnt_name"]."<br>";
				send_mail($email_creator,$subj,$text,null);

				Table_Update("move_staff",array("id"=>$k),array("accepted"=>1));
			}
		}
	}
}

$p = array(':dpt_id' => $_SESSION["dpt_id"]);

$sql=rtrim(file_get_contents('sql/move_staff.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($data as $k=>$v)
{
$p = array(':id' => $v["id"]);
$sql=rtrim(file_get_contents('sql/move_staff_accept_bud_fil.sql'));
$sql=stritr($sql,$p);
$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$data[$k]['bud_fil']=$data1;
}


//print_r($data);

$smarty->assign('move_staff', $data);


$sql=rtrim(file_get_contents('sql/dolgn_list.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dolgn_list_all', $data);


$smarty->display('move_staff_accept.html');

?>