<?

if (isset($_REQUEST["move_staff"]))
{
	$id = get_new_id();
	$_REQUEST["move_staff"]["id"]=$id;
	$dm=$_REQUEST["move_staff"]["datamove"];
	$_REQUEST["move_staff"]["datamove"]=OraDate2MDBDate($_REQUEST["move_staff"]["datamove"]);
	$_REQUEST["move_staff"]["creator"]=$tn;
	if (isset($_FILES['fn']))
	{
		if (is_uploaded_file($_FILES['fn']['tmp_name']))
		{
			$d1="files/move_staff_files";
			if (!file_exists($d1)) {mkdir($d1,0777,true);}
			$fn=get_new_file_id().'_'.$_FILES['fn']["name"];
			move_uploaded_file($_FILES['fn']["tmp_name"], $d1."/".translit($fn));
			$_REQUEST["move_staff"]["fn"]=translit($fn);
		}
	}
	Table_Update("move_staff",$_REQUEST["move_staff"],$_REQUEST["move_staff"]);
	if (isset($_REQUEST['bud_fil']))
	{
		foreach($_REQUEST['bud_fil'] as $k=>$v)
		{
			$keys = array('id'=>get_new_id(),'parent'=>$id);
			$vals = array('fil'=>$v);
			Table_Update("move_staff_bud_fil",$keys,$vals);
		}
	}


	$res=$db->getAll("select e_mail from user_list where is_admin=1 and e_mail is not null", null, null, null, MDB2_FETCHMODE_ASSOC);
	$creator_fio=$db->getOne("select fio from user_list where tn=".$_REQUEST["move_staff"]["creator"]);
	$free_fio=$db->getOne("select fio from user_list where tn=".$_REQUEST["move_staff"]["tn"]);
	foreach($res as $k=>$v)
	{
		$subj="Поступила заявка на перевод сотрудника";
		$text="Здравствуйте.<br>";
		$text.="Поступила заявка на перевод сотрудника<br>";
		$text.="Ф.И.О. переводимого: ".$free_fio."<br>";
		$text.="Ф.И.О. подавшего заявку: ".$creator_fio."<br>";
		$text.="Дата перевода: ".$dm."<br>";
		$text.="Страна: ".$_SESSION["cnt_name"]."<br>";
		send_mail($v["e_mail"],$subj,$text,null);
	}
}

$p = array(':tn' => $tn,':dpt_id' => $_SESSION["dpt_id"]);

$sql=rtrim(file_get_contents('sql/dolgn_list.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dolgn_list_all', $data);

$sql=rtrim(file_get_contents('sql/bud_fil.sql'));
$sql=stritr($sql,$p);
$bud_fil = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_fil', $bud_fil);

$sql=rtrim(file_get_contents('sql/move_staff_my_emp.sql'));
$params=array(':tn'=>$tn);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('my_emp', $data);

$smarty->display('move_staff.html');

?>