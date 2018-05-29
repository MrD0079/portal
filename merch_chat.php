<?php
//ini_set('display_errors', 'On');
if (isset($_REQUEST["add_comment"]))
{
	if ($_REQUEST["add_comment"]!='')
	{
		$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
		$table_name = "merch_chat";
		$id=get_new_id();
		$keys = array(
			'id'=>$id,
			'login'=>$login,
			'dt'=>OraDate2MDBDate($_REQUEST["dt"]),
			'ag_id'=>$_REQUEST["ag_id"],
			'kod_tp'=>$_REQUEST["kod_tp"],
			'lu'=>null
		);
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
					move_uploaded_file($z["tmp_name"][$k], "files/merch_chat_files/".$fn);
					$image = new SimpleImage();
					$image->load("files/merch_chat_files/".$fn);
					$h=$image->getHeight();
					if ($image->getHeight()>600)
					{
						$image->resizeToHeight(600);
					}
					$image->save("files/merch_chat_files/".$fn);
					$keys = array("chat_id"=>$id,"fn"=>$fn);
					Table_Update ("merch_chat_f", $keys, $keys);
				}
			}
		}
		$db->query('BEGIN pr_send_m_chat ('.$id.'); END;');
	}
	if (isset($_REQUEST["close_comment"]))
	{
		$table_name = "merch_chat_closed";
		$keys = array(
			'dt'=>OraDate2MDBDate($_REQUEST["dt"]),
			'ag_id'=>$_REQUEST["ag_id"],
			'kod_tp'=>$_REQUEST["kod_tp"]
		);
		Table_Update ($table_name, $keys, $keys);
	}
}
else
{
	$p=array(
		':dt'=>"'".$_REQUEST["dt"]."'",
		':ag_id'=>$_REQUEST["ag_id"],
		':kod_tp'=>$_REQUEST["kod_tp"]
	);

	$sql = rtrim(file_get_contents('sql/merch_chat_closed.sql'));
	$sql=stritr($sql,$p);
	$res = $db->getOne($sql);
	$_REQUEST["chat_closed"]=$res;

	$sql = rtrim(file_get_contents('sql/merch_chat.sql'));
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('chat', $res);
	$sql = rtrim(file_get_contents('sql/merch_chat_f.sql'));
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('chat_f', $res);
	$_REQUEST["dt1"] = OraDate2MDBDate($_REQUEST["dt"],'%Y%m%d');
	$smarty->display('merch_chat.html');
}
?>