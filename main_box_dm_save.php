<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$_FILES = recursive_iconv ('UTF-8', 'Windows-1251', $_FILES);
if (isset($_REQUEST["new"]))
{
	
	echo "���� ��������� ���������� ������������";
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
	$subj = "��������� �� ������� ����� ������������ DM";
	$text = "� ��� ��������� ��������� ".$fio.", ".$_SESSION["my_pos_name"].", ".$_SESSION["my_department_name"].".<br>";
	$text .= "����� �������: <br>";
	$text .= "����������� �������� � ������? ";
	if ($_REQUEST['ag_problem']==1)
	{
		$text .= "��<br>";
		$text .= "����� �������� ���� ������������(����� \"�������� �� ������\")? ";
		$_REQUEST['ag_send_db']==1 ? $text .= "��" : $text .= "���";
		$text .= "<br>";
		$fil_name = $db->getOne("select name from bud_fil where id = ".$_REQUEST['ag_fil']);
		$text .= "�� ����� ������� �������� �����? ".$fil_name."<br>";
	}
	else
	{
		$text .= "���<br>";
	}
	$cat_appeal_name = $db->getOne("select name from dm_cat_appeals where id = ".$_REQUEST['cat_appeal']);
	$text .= "��������� �������: ".$cat_appeal_name."<br>";
	$text .= "��������� �������� ��������: ".$_REQUEST['text'];
	$dm_mail = $db->getOne("select e_mail from user_list where tn = ".$_REQUEST['dm']);
	send_mail($dm_mail,$subj,$text);
}
if (isset($_REQUEST["answer"]))
{
	echo "��� ����� ���������";
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
	echo "���� ������� �������������";
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
	echo "���� ������� ����������";
	$keys = array(
		'id'=>$_REQUEST['box_id'],
	);
	$vals = array(
		'closed_init'=>1,
	);
	Table_Update('box_dm', $keys,$vals);
}
?>