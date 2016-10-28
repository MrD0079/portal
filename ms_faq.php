<?

if (
	isset($_FILES["ms_faq"])
	&&
	$_FILES['ms_faq']['error']==0
	&&
	is_uploaded_file($_FILES["ms_faq"]["tmp_name"])
)
{
		$db->query("truncate table ms_faq");
		$fn = "ms_faq_".get_new_file_id().'_'.translit($_FILES["ms_faq"]["name"]);
		$path = "files/".$fn;
		move_uploaded_file($_FILES["ms_faq"]["tmp_name"],$path);
		$vals=array('fn'=>$fn,'path'=>$path);
		Table_Update('ms_faq',$vals,$vals);
}

$sql="select path,fn from ms_faq";
$f = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ms_faq', $f);

$smarty->display('ms_faq.html');



?>