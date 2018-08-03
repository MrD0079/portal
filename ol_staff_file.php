<?



if (isset($_REQUEST['save']))
{
	if (isset($_FILES["filereport"]))
	{
		if ($_FILES["filereport"]['name']!="")
		{
			if (!file_exists("files/ol_files/".$_REQUEST['sid'])) {mkdir ("files/ol_files/".$_REQUEST['sid'],0777);}
			if (is_uploaded_file($_FILES["filereport"]["tmp_name"]))
			{
				$_FILES = recursive_iconv ('UTF-8', 'Windows-1251', $_FILES);
				$fn=translit($_FILES["filereport"]['name']);
				move_uploaded_file(
					$_FILES["filereport"]["tmp_name"],
					"files/ol_files/".$_REQUEST['sid']."/".$fn
				);
				$id=get_new_id();
				Table_Update(
					"ol_staff_files",
					array("id"=>$id,"ol_staff_id"=>$_REQUEST['sid']),
					array("fn"=>$fn)
				);
				$smarty->assign('fn', $fn);
				$smarty->assign('id', $id);
			}
		}
	}
}

if (isset($_REQUEST["del"])&&isset($_REQUEST["file_id"]))
{
	$fn=$db->getOne('select fn from ol_staff_files where id='.$_REQUEST["file_id"]);
	$sid=$db->getOne('select ol_staff_id from ol_staff_files where id='.$_REQUEST["file_id"]);
	$fn="files/ol_files/".$sid."/".$fn;
	unlink($fn);
	Table_Update(
		"ol_staff_files",
		array("id"=>$_REQUEST["file_id"]),
		null
	);
}

$smarty->display('ol_staff_file.html');

?>