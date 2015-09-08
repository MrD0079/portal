<?

//ses_req();


//print_r($_FILES);

//InitRequestVar("dt",$now);

//$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);













$keys = array(
	'head_id'=>$_REQUEST['head'],
	'to_id'=>$_REQUEST['to_id']
);

Table_Update('beg_visit_to', $keys,$keys);




$parent_id = $db->getOne('select id from beg_visit_to where head_id='.$_REQUEST['head'].' and to_id='.$_REQUEST['to_id']);


//echo ($parent_id);

//print_r($_REQUEST);


$keys = array(
	'parent_id'=>$parent_id,
	'lu'=>null
);


if (isset($_FILES['img']))
{
foreach($_FILES['img']['name'] as $k=>$v)
{

	include_once('SimpleImage.php');
	if
	(
		is_uploaded_file($_FILES['img']['tmp_name'][$k])
	)
	{
		$a=pathinfo($_FILES['img']['name'][$k]);
		$id=get_new_file_id();
		$fn="beg_visit_to_f_".$id.".".$a["extension"];
		$vals=array('fn'=>$fn);
		Table_Update('beg_visit_to_f', $keys,$vals);
		if (!file_exists('beg_visit_to_f_files')) {mkdir('beg_visit_to_f_files',0777,true);}
		move_uploaded_file($_FILES['img']['tmp_name'][$k], 'beg_visit_to_f_files/'.$fn);

		$image = new SimpleImage();
		$image->load('beg_visit_to_f_files/'.$fn);
		$h=$image->getHeight();
		if ($image->getHeight()>600)
		{
		$image->resizeToHeight(600);
		}
		$image->save('beg_visit_to_f_files/'.$fn);

		//$smarty->assign('fn',$fn);
		//$smarty->display('beg_visit_2_to_f_save.html');
	}
	else
	{
		echo 'Ошибка загрузки файла<br>';
	}
}
}

//$vals=array($_REQUEST['field']=>$_REQUEST['val']);

//Table_Update('beg_visit_to_'.$_SESSION["cnt_kod"], $keys,$vals);

$params=array(
	':parent_id'=>$parent_id
);
$sql = rtrim(file_get_contents('sql/beg_visit2_to_f.sql'));
$sql=stritr($sql,$params);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);
$smarty->display('beg_visit_2_to_f_save.html');


//echo 'beg_visit_grup_'.$_SESSION["cnt_kod"];
//print_r($keys);
//print_r($vals);






//echo $now;

?>