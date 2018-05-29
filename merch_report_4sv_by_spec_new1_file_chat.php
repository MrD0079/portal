<?php
//ini_set('display_errors', 'On');
if (isset($_REQUEST["add_comment"]))
{
	if ($_REQUEST["add_comment"]!='')
	{
		$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
		$table_name = "MERCH_SPEC_REPORT_FILES_CHAT";
		$id=get_new_id();
		$keys = array('id'=>$id,'login'=>$login,'MSR_FILE_ID'=>$_REQUEST["id"],'lu'=>null);
		$values = array('text'=>$_REQUEST["add_comment"]);
		Table_Update ($table_name, $keys, $values);
		if (isset($_FILES["files"]))
		{
			include_once('SimpleImage.php');
			$z = $_FILES["files"];
			foreach ($z['tmp_name'] as $k=>$v)
			{
				if (is_uploaded_file($z["tmp_name"][$k]))
				{
					$fn=get_new_file_id()."_".translit(iconv ('UTF-8', 'Windows-1251', $z["name"][$k]));
					move_uploaded_file($z["tmp_name"][$k], "files/merch_spec_report_files_chat_files/".$fn);
					$image = new SimpleImage();
					$image->load("files/merch_spec_report_files_chat_files/".$fn);
					$h=$image->getHeight();
					if ($image->getHeight()>600)
					{
						$image->resizeToHeight(600);
					}
					$image->save("files/merch_spec_report_files_chat_files/".$fn);
					$keys = array("chat_id"=>$id,"fn"=>$fn);
					Table_Update ("merch_spec_report_files_chat_f", $keys, $keys);
				}
			}
		}
		$db->query('BEGIN pr_send_msrf_chat ('.$id.'); END;');
	}
	if (isset($_REQUEST["close_comment"]))
	{
		$table_name = "MERCH_SPEC_REPORT_FILES";
		$keys = array('ID'=>$_REQUEST["id"]);
		$values = array('chat_closed'=>1);
		Table_Update ($table_name, $keys, $values);
	}
}
else
{
	$_REQUEST["chat_closed"]=$db->getOne('select chat_closed from merch_spec_report_files where id='.$_REQUEST["id"]);
	$p=array(':msr_file_id'=>$_REQUEST["id"]);
	$sql = rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new1_file_chat.sql'));
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('chat', $res);
	$sql = rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new1_file_chat_f.sql'));
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('chat_f', $res);
	$smarty->display('merch_report_4sv_by_spec_new1_file_chat.html');
}
?>