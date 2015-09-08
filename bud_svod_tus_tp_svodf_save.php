<?

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);

if (isset($_REQUEST['id']))
{
	Table_Update('sc_svodf', array('id'=>$_REQUEST['id']), null);
}

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
		$fn=$id.'_'.translit($_FILES['file']['name']);
		$vals=array('fn'=>$fn,'summa'=>$_REQUEST['summa']);

	$keys = array(
		'tn'=>$tn,
		'dt'=>OraDate2MDBDate($_REQUEST['dt']),
		'dpt_id' => $_SESSION["dpt_id"],
		'summa'=>$_REQUEST['summa'],
		'fn'=>$fn
	);

		Table_Update('sc_svodf', $keys, $keys);
/*
$_REQUEST['keys']=$keys;
$_REQUEST['vals']=$vals;
ses_req();
*/

		if (!file_exists('bud_svod_sc_files')) {mkdir('bud_svod_sc_files',0777,true);}
		move_uploaded_file($_FILES['file']['tmp_name'], 'bud_svod_sc_files/'.$fn);
	}
	else
	{
		echo 'Ошибка загрузки файла<br>';
	}
}

?>




