<?

//ses_req();

//print_r($_FILES);

InitRequestVar('files_activ',1);

//ses_req();

if (isset($_REQUEST["new_section"]))
{
	Table_Update('files_sections',$_REQUEST["new_section"],$_REQUEST["new_section"]);
}

if (
	isset($_REQUEST["new_file"])
	&&
	isset($_FILES["new_file"])
	&&
	$_FILES['new_file']['error']==0
	&&
	is_uploaded_file($_FILES["new_file"]["tmp_name"])
	&&
	isset($_REQUEST["new_file_dpt"])
)
{
	foreach ($_REQUEST["new_file_dpt"] as $k=>$v)
	{
		$path = "files/faq_".get_new_file_id().'_'.translit($_FILES["new_file"]["name"]);
		copy($_FILES["new_file"]["tmp_name"],$path);
		$vals=$_REQUEST["new_file"];
		$vals["path"]=$path;
		$sql='SELECT fn_check_file_section (:h_name, :dpt_id) FROM DUAL';
		$params=array(':h_name'=>"'".$vals['section']."'",':dpt_id' => $v);
		$sql=stritr($sql,$params);
		$section_id = $db->getOne($sql);
		$vals['section'] = $section_id;
		//var_dump($vals);
		Table_Update('files',$vals,$vals);
	}
}


if (isset($_REQUEST["update"]))
{
	foreach ($_REQUEST["update"] as $k=>$v)
	{
		$table=$k;
		foreach($v as $k1=>$v1)
		{
			$keys=array("id"=>$k1);
			$values=$v1;
			Table_Update($table,$keys,$values);
			/*echo  "update ".$table;
			print_r($keys);
			print_r($values);
			echo "<br>";*/
		}
	}
}

if (isset($_FILES["update"]))
{
	foreach ($_FILES["update"]["name"] as $k=>$v)
	{
		$table=$k;
		foreach($v as $k1=>$v1)
		{
			if (is_uploaded_file($_FILES["update"]["tmp_name"][$k][$k1]['avatar']))
			{
				$path = "files/faq_avatar_".get_new_file_id().'_'.translit($v1['avatar']);
				move_uploaded_file($_FILES["update"]["tmp_name"][$k][$k1]['avatar'],$path);
				$keys=array("id"=>$k1);
				$vals=array('avatar'=>$path);
				Table_Update($table,$keys,$vals);
			}
		}
	}
}

if (isset($_REQUEST["delete"]))
{
	foreach ($_REQUEST["delete"] as $k=>$v)
	{
		$table=$k;
		foreach($v as $k1=>$v1)
		{
		$keys=array("id"=>$k1);
		Table_Update($table,$keys,null);
		if ($v1!='')
		{
		unlink($v1);
		}
			/*echo  "delete ".$table."-".$k1."-".$v1;
			print_r($keys);
			echo "<br>";*/
		}
	}
}


$sql=rtrim(file_get_contents('sql/files_sections.sql'));
$files = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('files_sections', $files);

$sql=rtrim(file_get_contents('sql/files.sql'));
$params=array(':pos_id'=>0,':dpt_id' => $_SESSION["dpt_id"],':files_activ'=>$_REQUEST["files_activ"]);
$sql=stritr($sql,$params);
$files = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('files', $files);



$smarty->display('files.html');



?>