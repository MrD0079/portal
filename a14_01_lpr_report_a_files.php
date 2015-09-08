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
	Table_Update('A14_01_LPR_photo_FILES',$keys,null);
	unlink('a14_01_lpr_files/'.$_REQUEST['fn']);
}



if (isset($_FILES['fotoreport']))
{
	include_once('SimpleImage.php');
	//$fn=$_FILES['fotoreport']['name'];
	if
	(
		is_uploaded_file($_FILES['fotoreport']['tmp_name'])
	)
	{
		$a=pathinfo($_FILES["fotoreport"]["name"]);

		$id=get_new_file_id();

		$fn="photo_".$_REQUEST['tp_kod']."_".$id.".".$a["extension"];

		$keys = array(
			'id'=>$id,
			'tp_kod'=>$_REQUEST['tp_kod'],
			'fn'=>$fn
		);
		Table_Update('A14_01_LPR_photo_FILES',$keys,$keys);

		move_uploaded_file($_FILES['fotoreport']['tmp_name'], 'a14_01_lpr_files/'.$fn);

		$image = new SimpleImage();
		$image->load('a14_01_lpr_files/'.$fn);
		$h=$image->getHeight();
		if ($image->getHeight()>600)
		{
		$image->resizeToHeight(600);
		}
		$image->save('a14_01_lpr_files/'.$fn);

		$smarty->assign('fn',$fn);
		$smarty->display('a14_01_lpr_report_a_files.html');
	}
	else
	{
		echo 'Ошибка загрузки файла<br>';
	}
}





?>