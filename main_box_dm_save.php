<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$_FILES = recursive_iconv ('UTF-8', 'Windows-1251', $_FILES);
if (isset($_REQUEST["new"]))
{
	
	echo "Ваше сообщение направлено координатору";
	$id=get_new_id();
	$keys = array(
		'id'=>$id,
		'creator'=>$tn,
		'dm'=>$_REQUEST['dm'],
		'ag_problem'=>$_REQUEST['ag_problem'],
		'ag_send_db'=>$_REQUEST['ag_send_db'],
		'ag_fil'=>$_REQUEST['ag_fil'],
		'cat_appeal'=>$_REQUEST['cat_appeal'],
	);
	Table_Update('box_dm', $keys,$keys);
	$keys = array(
		'box_id'=>$id,
		'tn'=>$tn,
		'text'=>$_REQUEST['text'],
	);
	Table_Update('box_dm_chat', $keys,$keys);
	if (isset($_FILES['files']))
	{
		foreach($_FILES['files']['name'] as $k=>$v)
		{
			if
			(
				is_uploaded_file($_FILES['files']['tmp_name'][$k])
			)
			{
				$a=pathinfo($_FILES['files']['name'][$k]);
				$fn=get_new_file_id().'_'.translit($_FILES['files']['name'][$k]);
				$keys = array('box_id'=>$id,'fn'=>$fn);
				Table_Update('box_dm_files', $keys,$keys);
				move_uploaded_file($_FILES['files']['tmp_name'][$k], 'files/'.$fn);
			}
		}
	}
	$subj = "Обращение на горячую линию координатора DM";
	$text = "К Вам обратился сотрудник ".$fio.", ".$_SESSION["my_pos_name"].", ".$_SESSION["my_department_name"].".<br>";
	$text .= "Текст запроса: <br>";
	$text .= "Техническая проблема у агента? ";
	if ($_REQUEST['ag_problem']==1)
	{
		$text .= "да<br>";
		$text .= "Агент отправил базу координатору(опция \"Сообщить об ошибке\")? ";
		$_REQUEST['ag_send_db']==1 ? $text .= "да" : $text .= "нет";
		$text .= "<br>";
		$fil_name = $db->getOne("select name from bud_fil where id = ".$_REQUEST['ag_fil']);
		$text .= "На каком филиале работает агент? ".$fil_name."<br>";
	}
	else
	{
		$text .= "нет<br>";
	}
	$cat_appeal_name = $db->getOne("select name from dm_cat_appeals where id = ".$_REQUEST['cat_appeal']);
	$text .= "Категория вопроса: ".$cat_appeal_name."<br>";
	$text .= "Детальное описание проблемы: ".$_REQUEST['text'];
	$dm_mail = $db->getOne("select e_mail from user_list where tn = ".$_REQUEST['dm']);
	send_mail($dm_mail,$subj,$text);
}
if (isset($_REQUEST["answer"]))
{
	echo "Ваш ответ отправлен";
	$keys = array(
		'box_id'=>$_REQUEST['box_id'],
		'tn'=>$tn,
		'text'=>$_REQUEST['text'],
	);
	Table_Update('box_dm_chat', $keys,$keys);
}
if (isset($_REQUEST["closed_dp"]))
{
	//print_r($_REQUEST);
	echo "Тема закрыта координатором";
	$keys = array(
		'id'=>$_REQUEST['box_id'],
	);
	$vals = array(
		'closed_dp'=>1,
	);
	Table_Update('box_dm', $keys,$vals);
}
if (isset($_REQUEST["closed_init"]))
{
	//print_r($_REQUEST);
	echo "Тема закрыта создателем";
	$keys = array(
		'id'=>$_REQUEST['box_id'],
	);
	$vals = array(
		'closed_init'=>1,
	);
	Table_Update('box_dm', $keys,$vals);
}
?>