<?
if (isset($_REQUEST["new"]))
{
	foreach ($_REQUEST["new"] as $k=>$v)
	{
			if ($v["name"]!='')
			{
				Table_Update("bud_ru_st_pri",$v,$v);
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
		Table_Update("bud_ru_st_pri",$keys,$values);
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
		Table_Update("bud_ru_st_pri",$keys,null);
		/*echo  "delete ".$table."-".$k1."-".$v1;
		print_r($keys);
		echo "<br>";*/
	}
}
$sql=rtrim(file_get_contents('sql/bud_ru_st_pri.sql'));
$params=array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$bud_ru_st_pri = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_ru_st_pri', $bud_ru_st_pri);
$smarty->display('bud_ru_st_pri.html');
?>