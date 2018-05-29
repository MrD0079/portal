<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$id=get_new_id();

if (is_uploaded_file($_FILES["pict"]['tmp_name']))
{
	$a=pathinfo($_FILES["pict"]["name"]);
	$fn="pict".get_new_file_id().".".$a["extension"];
	$_REQUEST['pict']=$fn;
	move_uploaded_file($_FILES["pict"]['tmp_name'], "files/ac_test_files/".$fn);

	include_once('SimpleImage.php');
	$image = new SimpleImage();
	$image->load("files/ac_test_files/".$fn);
	$h=$image->getHeight();
	if ($image->getHeight()>600)
	{
	$image->resizeToHeight(600);
	}
	$image->save("files/ac_test_files/".$fn);
}
else
{
	$_REQUEST['pict']=null;
}

$keys = array('id'=>$id,'name'=>$_REQUEST['name'],'q_sort'=>$_REQUEST['q_sort'],'pict'=>$_REQUEST['pict'],'parent'=>$_REQUEST['parent']);
Table_Update('ac_test', $keys,$keys);
$smarty->assign('id',$id);
$smarty->assign('name',$_REQUEST['name']);
$smarty->assign('q_sort',$_REQUEST['q_sort']);
$smarty->assign('pict',$_REQUEST['pict']);
$smarty->display('ac_test_q_new.html');
?>