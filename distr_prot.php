<?




InitRequestVar('da_db',0);
InitRequestVar('da_di',0);
InitRequestVar('da_re','0');
InitRequestVar('da_de','0');
InitRequestVar('da_st',0/*$db->getOne('SELECT id FROM distr_prot_status WHERE def_val = 1')*/);
InitRequestVar('da_ok_chief',0/*$db->getOne('SELECT id FROM distr_prot_ok_chief WHERE def_val = 1')*/);
InitRequestVar('da_ok_nm',0/*$db->getOne('SELECT id FROM distr_prot_ok_chief WHERE def_val = 1')*/);
InitRequestVar('da_ok_dpu',0/*$db->getOne('SELECT id FROM distr_prot_ok_chief WHERE def_val = 1')*/);
InitRequestVar('da_sd',$_REQUEST['month_list']);
InitRequestVar('da_ed',$_REQUEST['month_list']);
InitRequestVar('da_cat',0);
InitRequestVar('da_conq',0);
InitRequestVar('da_full',0/*$db->getOne('SELECT id FROM distr_prot_full WHERE def_val = 1')*/);
InitRequestVar('da_result',0/*$db->getOne('SELECT id FROM distr_prot_result WHERE def_val = 1')*/);
InitRequestVar('da_deleted',0);
InitRequestVar("prot_id",0);





audit("открыл distr_prot","distr");
$p = array(":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);


$p[':da_deleted']=$_REQUEST['da_deleted'];
$p[':da_db']=$_REQUEST['da_db'];
$p[':da_di']=$_REQUEST['da_di'];
$p[':da_result']=$_REQUEST['da_result'];
$p[':da_re']="'".$_REQUEST['da_re']."'";
$p[':da_de']="'".$_REQUEST['da_de']."'";
$p[':da_st']=$_REQUEST['da_st'];
$p[':da_ok_chief']=$_REQUEST['da_ok_chief'];
$p[':da_ok_nm']=$_REQUEST['da_ok_nm'];
$p[':da_ok_dpu']=$_REQUEST['da_ok_dpu'];
$p[':da_sd']="'".$_REQUEST['da_sd']."'";
$p[':da_ed']="'".$_REQUEST['da_ed']."'";
$p[':da_cat']=$_REQUEST['da_cat'];
$p[':da_conq']=$_REQUEST['da_conq'];
$p[':da_full']=$_REQUEST['da_full'];
$p[':prot_id']=$_REQUEST['prot_id'];


$sql=rtrim(file_get_contents('sql/distr_prot_db.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('da_db', $x);

$sql=rtrim(file_get_contents('sql/distr_prot_di.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('da_di', $x);

$sql=rtrim(file_get_contents('sql/distr_prot_re.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('da_re', $x);

$sql=rtrim(file_get_contents('sql/distr_prot_de.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('da_de', $x);

$sql=rtrim(file_get_contents('sql/distr_prot_full.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('da_full', $x);

$sql=rtrim(file_get_contents('sql/distr_prot_st.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('da_st', $x);

$sql=rtrim(file_get_contents('sql/distr_prot_cat.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('cat', $x);

$sql=rtrim(file_get_contents('sql/distr_prot_conq.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('conq', $x);

$sql=rtrim(file_get_contents('sql/distr_prot_ok_chief.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('da_ok_chief', $x);

$sql=rtrim(file_get_contents('sql/distr_prot_result.sql'));
$sql=stritr($sql,$p);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('da_result', $x);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

//print_r($p);

if (isset($_REQUEST['refresh']))
{
	if ($_REQUEST["prot_id"]!=0)
	{
		$sql=rtrim(file_get_contents('sql/distr_prot_find.sql'));
		$sql=stritr($sql,$p);
		$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		if (isset($data))
		{
			$smarty->assign('find_prot', $data);
			$params[":da_sd"]="'01.01.1900'";
			$params[":da_ed"]="'31.12.2050'";
			$params[':da_db']=0;
			$params[':da_di']=0;
			$params[':da_re']='0';
			$params[':da_de']='0';
			$params[':da_st']=0;
			$params[':da_ok_chief']=0;
			$params[':da_ok_nm']=0;
			$params[':da_ok_dpu']=0;
			$params[':da_cat']=0;
			$params[':da_conq']=0;
			$params[':da_full']=0;
			$params[':da_result']=0;
			$params[':da_deleted']=0;
		}
	}
	$sql=rtrim(file_get_contents('sql/distr_prot.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$distr_prot = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($distr_prot as $k=>$v)
	{
		$pf = array(':id'=>$v['id']);
		$sqlf=rtrim(file_get_contents('sql/distr_prot_files.sql'));
		$sqlf=stritr($sqlf,$pf);
		//echo $sql;
		$f = $db->getAll($sqlf, null, null, null, MDB2_FETCHMODE_ASSOC);
		$distr_prot[$k]['files']=$f;
	}
	$smarty->assign('distr_prot', $distr_prot);
}

$smarty->display('distr_prot.html');

?>