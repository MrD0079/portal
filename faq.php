<?
$sql=rtrim(file_get_contents('sql/files_faq.sql'));
$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=stritr($sql,$params);
$files = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$d = array();
foreach ($files as $k=>$v)
{
	if ($v['parent']==null)
	{
		$d[$v['id']]['section']=$v;
	}
	else
	{
		$d[$v['parent']]['files'][$v['id']]=$v;
	}
}
$smarty->assign('data', $d);
$smarty->display('faq.html');
?>