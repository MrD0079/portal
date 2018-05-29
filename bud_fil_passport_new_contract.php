<?

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);

if (isset($_REQUEST['del']))
{
	$keys = array(
		'id'=>$_REQUEST['del'],
	);
	Table_Update('bud_fil_contracts', $keys,null);
}
else
{
if (isset($_FILES['img']))
{
$_FILES = recursive_iconv ('UTF-8', 'Windows-1251', $_FILES);
$f=array();
foreach($_FILES['img']['name'] as $k=>$v)
{
	if
	(
		is_uploaded_file($_FILES['img']['tmp_name'][$k])
	)
	{
		$a=pathinfo($_FILES['img']['name'][$k]);
		$id=get_new_id();
		$fn=get_new_file_id().'_'.translit($_FILES['img']['name'][$k]);
		$keys = array('id'=>$id,'fil'=>$_REQUEST['parent']);
		$vals = array('fn'=>$fn);
		$f[$id]=$fn;
		Table_Update('bud_fil_contracts', $keys,$vals);
		if (!file_exists('bud_fil_files')) {mkdir('bud_fil_files',0777,true);}
		move_uploaded_file($_FILES['img']['tmp_name'][$k], 'files/'.$fn);
	}
}
}
//$smarty->assign('id',$id);
$smarty->assign('f',$f);
$smarty->display('bud_fil_passport_new_contract.html');
}
?>