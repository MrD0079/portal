<?

//ses_req();

	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('dt'=>OraDate2MDBDate($_REQUEST['dt']));
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	//$_REQUEST['table']=='m'?$keys['dpt_id']=$_SESSION['dpt_id']:null;
	$_REQUEST['table']=='f'?$keys['fil']=$_REQUEST['key2']:null;
	//$_REQUEST['table']=='f'&&$_REQUEST['val']==null&&$_REQUEST['field']=='coach'?$vals=null:null;
	Table_Update('bud_svod_ta'.$_REQUEST['table'], $keys,$vals);

if (isset($_FILES['file']))
{
$_FILES = recursive_iconv ('UTF-8', 'Windows-1251', $_FILES);
	if
	(
		is_uploaded_file($_FILES['file']['tmp_name'])
	)
	{
		$a=pathinfo($_FILES['file']['name']);
		$id=get_new_file_id();
		//$keys['id']=$id;
		$fn=$id.'_'.translit($_FILES['file']['name']);
		$vals=array('prot_db'=>$fn);
		Table_Update('bud_svod_ta'.$_REQUEST['table'], $keys,$vals);
		if (!file_exists('bud_svod_ta_files')) {mkdir('bud_svod_ta_files',0777,true);}
		move_uploaded_file($_FILES['file']['tmp_name'], 'bud_svod_ta_files/'.$fn);
	}
	else
	{
		echo 'Ошибка загрузки файла<br>';
	}
}

/*
	if ($_REQUEST['field']=='ok_dpu_tn'&&$_REQUEST['val']!='')
	{
		$accept1=$parameters["accept1"]["val_string"];
		$accept2=$parameters["accept2"]["val_string"];
		$period=$db->getOne("select mt||' '||y from calendar where data=to_date('".$_REQUEST['dt']."','dd.mm.yyyy')");
		$subj='КПР департамента персонала за '.$period;
		$text = $smarty->fetch('kc.html');
		send_mail($accept1,$subj,$text,null);
		send_mail($accept2,$subj,$text,null);
		$sql="SELECT fio, e_mail FROM user_list WHERE is_ndp = 1 AND dpt_id = ".$_SESSION["dpt_id"]." AND datauvol IS NULL";
		$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		foreach ($x as $k=>$v){send_mail($v['e_mail'],$subj,'Отчет за '.$period.' согласован ЗГДП',null);}
	}
*/


?>