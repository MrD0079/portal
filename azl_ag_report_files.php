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
	Table_Update('azl_ag_files',$keys,null);
	unlink('azl_ag_report_photo/'.$_REQUEST['fn']);
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

		$fn="azl_".$_REQUEST['tz']."_".$_REQUEST['dt']."_".$id.".".$a["extension"];

		$keys = array(
			'id'=>$id,
			'tz'=>$_REQUEST['tz'],
			'dt'=>OraDate2MDBDate($_REQUEST['dt']),
			'fn'=>$fn
		);
		Table_Update('azl_ag_files',$keys,$keys);

		move_uploaded_file($_FILES['fotoreport']['tmp_name'], 'azl_ag_report_photo/'.$fn);
		$smarty->assign('fn',$fn);
		$smarty->display('azl_ag_report_files.html');
	}
	else
	{
		echo 'Ошибка загрузки файла<br>';
	}
}





?>