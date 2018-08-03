<?



//print_r($_beg_to);
if (isset($_REQUEST["new"]))
{
	foreach ($_REQUEST["new"] as $k=>$v)
	{
			if ($v["name"]!='')
			{
				Table_Update("beg_to",$v,$v);
				/*echo  "insert ".$table;
				print_r($keys);
				print_r($values);
				echo "<br>";*/
			}
	}
}


if (isset($_REQUEST["update"]))
{
	foreach ($_REQUEST["update"] as $k=>$v)
	{
		$keys=array("id"=>$k);
		$values=$v;
		Table_Update("beg_to",$keys,$values);
		/*echo  "update ".$table;
		print_r($keys);
		print_r($values);
		echo "<br>";*/
	}
}


if (isset($_REQUEST["delete"]))
{
	foreach ($_REQUEST["delete"] as $k=>$v)
	{
		$keys=array("id"=>$k);
		Table_Update("beg_to",$keys,null);
		/*echo  "delete ".$table."-".$k1."-".$v1;
		print_r($keys);
		echo "<br>";*/
	}
}



$sql=rtrim(file_get_contents('sql/beg_to.sql'));
$params=array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$beg_to = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('beg_to', $beg_to);



$smarty->display('beg_to.html');



?>