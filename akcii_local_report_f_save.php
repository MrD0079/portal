<?



//print_r($_FILES);

//InitRequestVar("dt",$now);

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);



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
		$vals=array(
			'z_id'=>$_REQUEST['z_id'],
			'bonus'=>$_REQUEST['bonus'],
			'tn'=>$tn,
			'fn'=>$fn
		);
		Table_Update('akcii_local_files', $vals,$vals);
		if (!file_exists('files/akcii_local_files')) {mkdir('files/akcii_local_files',0777,true);}
		move_uploaded_file($_FILES['file']['tmp_name'], 'files/akcii_local_files/'.$fn);
	}
	else
	{
		echo 'Ошибка загрузки файла<br>';
	}
}


InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);

$params=array(
	':z_id' => $_REQUEST["z_id"],
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
);

$sql = rtrim(file_get_contents('sql/akcii_local_report_files.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('f', $x);

$smarty->display('akcii_local_report_files.html');


?>