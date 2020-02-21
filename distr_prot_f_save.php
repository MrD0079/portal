<?

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);

if (isset($_REQUEST['del']))
{
	$keys = array(
		'id'=>$_REQUEST['del'],
	);
	$vals=array(
		'deleted'=>1,
		'deleted_fio'=>$fio,
	);
	Table_Update('distr_prot', $keys,$vals);
}
else
{
if (isset($_FILES['img']))
{
	$id=get_new_id();
	//echo $id;
	$vals=array(
		'id'=>$id,
		'distr'=>$_REQUEST['distr'],
		'comm'=>$_REQUEST['comm'],
		'cat'=>$_REQUEST['cat'],
		'conq'=>$_REQUEST['conq'],
		'result'=>$_REQUEST['result'],
		'lu_tn'=>$tn,
		'lu_fio'=>$fio,
		"dpt_id" => $_SESSION["dpt_id"],
	);
	Table_Update('distr_prot', $vals,$vals);
	$_FILES = recursive_iconv ('UTF-8', 'Windows-1251', $_FILES);
	foreach($_FILES['img']['name'] as $k=>$v)
	{
		if
		(
			is_uploaded_file($_FILES['img']['tmp_name'][$k])
		)
		{
			$a=pathinfo($_FILES['img']['name'][$k]);
			$fn=get_new_file_id().'_'.translit($_FILES['img']['name'][$k]);
			$vals=array(
				'prot'=>$id,
				'fn'=>$fn
			);
			//print_r($vals);

			if (!file_exists('files/distr_prot_files')) {mkdir('files/distr_prot_files',0777,true);}
			$move_uploaded_file = move_uploaded_file($_FILES['img']['tmp_name'][$k], 'files/distr_prot_files/'.$fn);
			if($move_uploaded_file)
                Table_Update('distr_prot_files', $vals,$vals);
		}
		else
		{
			echo 'Ошибка загрузки файла<br>';
		}
	}
}
echo "Файлы успешно загружены";
}
?>