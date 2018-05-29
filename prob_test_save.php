<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$keys = array('id'=>$_REQUEST['id']);
Table_Update('prob_test', $keys,$keys);

if ($_REQUEST['field']=='pict')
{
	if (is_uploaded_file($_FILES["pict"]['tmp_name']))
	{
		$a=pathinfo($_FILES["pict"]["name"]);
		$fn="pict".get_new_file_id().".".$a["extension"];
		$_REQUEST['val']=$fn;
		move_uploaded_file($_FILES["pict"]['tmp_name'], "files/prob_test_files/".$fn);

		include_once('SimpleImage.php');
		$image = new SimpleImage();
		$image->load("files/prob_test_files/".$fn);
		$h=$image->getHeight();
		if ($image->getHeight()>600)
		{
		$image->resizeToHeight(600);
		}
		$image->save("files/prob_test_files/".$fn);

		echo '<a target=_blank href="files/prob_test_files/'.$_REQUEST['val'].'"><img height=50px src="files/prob_test_files/'.$_REQUEST['val'].'"></a>';
	}
}


if ($_REQUEST['field']=='id')
{
	if ($_REQUEST['val']==0){Table_Update('prob_test', $keys,null);}
}
else
{
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	Table_Update('prob_test', $keys,$vals);
}


?>




