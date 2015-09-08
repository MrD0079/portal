<?

if (isset($_REQUEST["save"]))
{
	$table_name = "fartuk_ua";
	$keys = array('tn'=>$tn);
	$values = $_REQUEST['d'];
	Table_Update ($table_name, $keys, $values);
}


$d1="fartuk_ua_files/".$tn;

if (isset($_REQUEST["del_file"]))
{
foreach ($_REQUEST["del_file"] as $k=>$v)
{
unlink($v);
}
}

if (isset($_FILES["fn"]))
{
if ($_FILES["fn"]["name"]!="")
{
	if (!file_exists($d1)) {mkdir($d1,0777,true);}
	if (is_uploaded_file($_FILES["fn"]['tmp_name'])){move_uploaded_file($_FILES["fn"]["tmp_name"], $d1."/".translit($_FILES["fn"]["name"]));}
}
}

		if (is_dir($d1))
		{
		if ($handle = opendir($d1)) {
			while (false !== ($file = readdir($handle)))
			{
				if ($file != "." && $file != "..") {$file_list[] = array("path"=>$d1,"file"=>$file);}
			}
			closedir($handle);
		}
		}
		isset($file_list)?$smarty->assign("fl", $file_list):null;

$d = $db->getRow('select * from fartuk_ua where tn='.$tn, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $d);

//ses_req();

$smarty->display('fartuk_ua_form.html');





?>