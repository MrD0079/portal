<?
//ses_req();
if (isset($_REQUEST["enabled1"]))
{
	$table="files_rights";
	foreach ($_REQUEST["enabled1"] as $k=>$v)
	{
		if ($v!='')
		{
			if ($v==1)
			{
				$keys=array("pos_id"=>$k,"file_id"=>$_REQUEST["id"]);
				$values=array("pos_id"=>$k,"file_id"=>$_REQUEST["id"]);
				Table_Update($table,$keys,$values);
			}
			if ($v==0)
			{
				$keys=array("pos_id"=>$k,"file_id"=>$_REQUEST["id"]);
				$values=null;
				Table_Update($table,$keys,$values);
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



$sql=rtrim(file_get_contents('sql/files_rights.sql'));
$params=array(':id'=>$_REQUEST["id"],':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$files_rights = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('files_rights', $files_rights);
$smarty->display('files_rights.html');
?>