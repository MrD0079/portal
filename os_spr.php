<?



//print_r($_os_spr);

if (isset($_REQUEST["new"]))
{
	foreach ($_REQUEST["new"] as $k=>$v)
	{
		$table=$k;
		foreach($v as $k1=>$v1)
		{
			$keys=array("id"=>-1/*$k1*/);
			$values=$v1;
			if ($values["name"]!='')
			{
				Table_Update($table,$keys,$values);
				/*echo  "insert ".$table;
				print_r($keys);
				print_r($values);
				echo "<br>";*/
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



$sql=rtrim(file_get_contents('sql/os_spr.sql'));
$os_spr = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('os_spr', $os_spr);



$smarty->display('os_spr.html');



?>