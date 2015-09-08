<?

//ses_req();

//print_r($_FILES);

//InitRequestVar("dt",$now);

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);



if (isset($_REQUEST['del_file']))
{
	unlink('os_ac_files/'.$db->getOne('select fn from os_ac_f where id='.$_REQUEST['del_file']));
	$keys = array(
		'id'=>$_REQUEST['del_file'],
	);
	Table_Update('os_ac_f', $keys,null);
}
else
{
if (isset($_FILES['img']))
{
$_FILES = recursive_iconv ('UTF-8', 'Windows-1251', $_FILES);
$keys = array(
	'memb_id'=>$_REQUEST['memb_id'],
	'ac_id'=>$_REQUEST['ac_id'],
	'id'=>null
);
if (isset($_FILES['img']))
{
foreach($_FILES['img']['name'] as $k=>$v)
{

	if
	(
		is_uploaded_file($_FILES['img']['tmp_name'][$k])
	)
	{
		$a=pathinfo($_FILES['img']['name'][$k]);
		$id=get_new_file_id();
		//$keys['id']=$id;
		$fn=$id.'_'.translit($_FILES['img']['name'][$k]);
		$vals=array('fn'=>$fn);
		Table_Update('os_ac_f', $keys,$vals);
		if (!file_exists('os_ac_files')) {mkdir('os_ac_files',0777,true);}
		move_uploaded_file($_FILES['img']['tmp_name'][$k], 'os_ac_files/'.$fn);
	}
	else
	{
		echo 'Ошибка загрузки файла<br>';
	}
}
}
}
$params=array(
	':memb_id'=>$_REQUEST['memb_id'],
	':ac_id'=>$_REQUEST['ac_id']
);
$sql = rtrim(file_get_contents('sql/os_ac_f.sql'));
$sql=stritr($sql,$params);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);
$smarty->display('os_ac_f_save.html');
}

?>