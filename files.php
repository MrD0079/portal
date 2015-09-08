<?

//ses_req();

//print_r($_FILES);

InitRequestVar('files_activ',1);


if (isset($_REQUEST["new"]))
{
	foreach ($_REQUEST["new"] as $k=>$v)
	{
		$table=$k;
		foreach($v as $k1=>$v1)
		{
			$keys=array("id"=>-1/*$k1*/);
			$values=$v1;

			if (isset($values["section"]))
			{
			if (isset($_FILES["new"]["tmp_name"]["files"][$values["section"]]["path"]))
			{
				move_uploaded_file(
					$_FILES["new"]["tmp_name"]["files"][$values["section"]]["path"],
					"files/".$_SESSION["cnt_kod"]."/".translit($_FILES["new"]["name"]["files"][$values["section"]]["path"])
				);
				$values["path"]="files/".$_SESSION["cnt_kod"]."/".translit($_FILES["new"]["name"]["files"][$values["section"]]["path"]);
			}
			}
			if ($values["name"]!='')
			{
				Table_Update($table,$keys,$values);
				//echo  "insert ".$table;
				//print_r($keys);
				//print_r($values);
				//echo "<br>";
			}
		}
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



$sql=rtrim(file_get_contents('sql/files.sql'));
$params=array(':pos_id'=>0,':dpt_id' => $_SESSION["dpt_id"],':files_activ'=>$_REQUEST["files_activ"]);
$sql=stritr($sql,$params);
$files = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('files', $files);



$smarty->display('files.html');



?>