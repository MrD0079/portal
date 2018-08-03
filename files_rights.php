<?

if (isset($_REQUEST["enabled1"]))
{
	$table="files_rights";
	foreach ($_REQUEST["enabled1"] as $k=>$v)
	{
	foreach ($v as $k1=>$v1)
	{
		if ($v1!='')
		{
			if ($v1==1)
			{
				$keys=array($k."_id"=>$k1,"file_id"=>$_REQUEST["id"]);
				$values=array($k."_id"=>$k1,"file_id"=>$_REQUEST["id"]);
				Table_Update($table,$keys,$values);
			}
			if ($v1==0)
			{
				$keys=array($k."_id"=>$k1,"file_id"=>$_REQUEST["id"]);
				$values=null;
				Table_Update($table,$keys,$values);
			}
		}
	}
	}
}
if (isset($_REQUEST["files_rassilka"]))
{
	$sql=rtrim(file_get_contents('sql/files_rassilka.sql'));
	$params=array(':dpt_id' => $_SESSION["dpt_id"],':id'=>$_REQUEST["id"]);
	$sql=stritr($sql,$params);
	$files_rassilka = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach($files_rassilka as $key=>$val)
	{
		send_mail($val["e_mail"],"«агрузка нового документа на портал",nl2br($val["pos_msg"]),null);
	}
}



$fn=$db->getOne("select name from files where id=".$_REQUEST["id"]);
$smarty->assign('fn', $fn);


$sql=rtrim(file_get_contents('sql/pers_cats.sql'));
$pers_cats = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pers_cats', $pers_cats);

$sql=rtrim(file_get_contents('sql/files_rights.sql'));
$params=array(':id'=>$_REQUEST["id"],':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$files_rights = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('files_rights', $files_rights);

$smarty->display('files_rights.html');
?>