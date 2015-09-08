<?


audit("открыл azl_visits","azl");

InitRequestVar('grp','');
InitRequestVar('sdt',$now);
InitRequestVar('edt',$now);


//ses_req();


$p = array(
	':sdt'=>"'".$_REQUEST['sdt']."'",
	':edt'=>"'".$_REQUEST['edt']."'"
);


if ($is_azl_super==1)
{
	if (isset($_REQUEST["generate"]))
	{
		$sql=rtrim(file_get_contents('sql/azl_visits_'.$_REQUEST['grp'].'.sql'));
		$sql=stritr($sql,$p);
		//echo "<hr>";
		//echo $sql;
		//echo "<hr>";
		$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		//print_r($data);
        
		foreach ($data as $k=>$v)
		{
			if (isset($v['id']))
			{
			if ($v['id']>0)
			{
			$sql=rtrim(file_get_contents('sql/azl_visits_'.$_REQUEST['grp'].'_visits.sql'));
			$p = array(
				":id" => $v['id'],
				':sdt'=>"'".$_REQUEST['sdt']."'",
				':edt'=>"'".$_REQUEST['edt']."'"
			);
			$sql=stritr($sql,$p);
			//echo $sql."<br>";
			$z1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			//print_r($z1);
			$data[$k]['visits']=$z1;
			}
			}
		}
		$smarty->assign('data', $data);
		//print_r($data);
	}
	$smarty->display('azl_visits.html');
}

?>