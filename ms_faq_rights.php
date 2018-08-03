<?

if (isset($_REQUEST["enabled1"]))
{
	$table="ms_faq_rights";
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

$fn=$db->getOne("select name from ms_faq where id=".$_REQUEST["id"]);
$smarty->assign('fn', $fn);

$sql=rtrim(file_get_contents('sql/ms_faq_rights.sql'));
$params=array(':id'=>$_REQUEST["id"]);
$sql=stritr($sql,$params);
$ms_faq_rights = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ms_faq_rights', $ms_faq_rights);

$smarty->display('ms_faq_rights.html');
?>