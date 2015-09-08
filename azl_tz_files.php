<?

/*
?><pre><?
print_r($_REQUEST);
//print_r($_FILES);
?></pre><?
*/


if (isset($_REQUEST['fn']))
{
	$keys = array(
	'fn'=>$_REQUEST['fn']
	);
	Table_Update('azl_tz_files',$keys,null);
	unlink('azl_promo_photo/'.$_REQUEST['fn']);
}



if (isset($_FILES['fotoreport']))
{
	//$fn=$_FILES['fotoreport']['name'];
	if
	(
		is_uploaded_file($_FILES['fotoreport']['tmp_name'])
	)
	{
		$a=pathinfo($_FILES["fotoreport"]["name"]);

		$id=get_new_file_id();

		$fn="azl_".$_REQUEST['tz']."_".$id.".".$a["extension"];

		$_REQUEST["fio"] = iconv('UTF-8', 'Windows-1251', $_REQUEST["fio"]);

		$keys = array(
			'id'=>$id,
			'tz'=>$_REQUEST['tz'],
			'fn'=>$fn,
			'fio'=>$_REQUEST["fio"]
		);
		Table_Update('azl_tz_files',$keys,$keys);

		move_uploaded_file($_FILES['fotoreport']['tmp_name'], 'azl_promo_photo/'.$fn);
		$smarty->assign('fn',$fn);
		$smarty->assign('promo_fio',$_REQUEST["fio"]);
		$smarty->display('azl_tz_files.html');
	}
	else
	{
		echo 'Ошибка загрузки файла<br>';
	}
}





?>