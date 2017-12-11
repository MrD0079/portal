<?

audit ("открыл учет ТМЦ","tmc");

if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["data"]))
	{
		$_REQUEST["data"] = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST["data"]);
		$_FILES = recursive_iconv ('UTF-8', 'Windows-1251', $_FILES);
		foreach ($_REQUEST["data"] as $k=>$v)
		{
			if (isset($_FILES["files"]["name"][$k]))
			{
				if (is_uploaded_file($_FILES["files"]["tmp_name"][$k]["fn"]))
				{
					$fn=get_new_file_id()."_".translit($_FILES["files"]["name"][$k]["fn"]);
					move_uploaded_file($_FILES["files"]["tmp_name"][$k]["fn"], "files/".$fn);
					$v["fn"] = $fn;
				}
			}
                        isset($v["removed"])&&($v["removed"]==1) ? $v["removed_fio"]=$fio : null;
			isset($v["dtr"]) ? $v["dtr"]=OraDate2MDBDate($v["dtr"]) : null;
			isset($v["zakup_dt"]) ? $v["zakup_dt"]=OraDate2MDBDate($v["zakup_dt"]) : null;
			isset($v["buh_dt"]) ? $v["buh_dt"]=OraDate2MDBDate($v["buh_dt"]) : null;
			Table_Update('tmc',array('id'=>$k),$v);
		}
	}
}

if (isset($_REQUEST["add"]))
{
	//ses_req();
	if (isset($_REQUEST["tmc_new"]))
	{
		if ($_REQUEST["tmc_new"]["name"]!=''&&$_REQUEST["tmc_new"]["tmcs"]!='')
		{
			$_REQUEST["tmc_new"] = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST["tmc_new"]);
                        $_FILES = recursive_iconv ('UTF-8', 'Windows-1251', $_FILES);
			if (isset($_FILES["tmc_new"]))
			{
				if (is_uploaded_file($_FILES["tmc_new"]["tmp_name"]["fn"]))
				{
					$fn=get_new_file_id()."_".translit($_FILES["tmc_new"]["name"]["fn"]);
					move_uploaded_file($_FILES["tmc_new"]["tmp_name"]["fn"], "files/".$fn);
					$_REQUEST["tmc_new"]["fn"] = $fn;
				}
			}
			isset($_REQUEST["tmc_new"]["dtv"]) ? $_REQUEST["tmc_new"]["dtv"]=OraDate2MDBDate($_REQUEST["tmc_new"]["dtv"]) : null;
			isset($_REQUEST["tmc_new"]["zakup_dt"]) ? $_REQUEST["tmc_new"]["zakup_dt"]=OraDate2MDBDate($_REQUEST["tmc_new"]["zakup_dt"]) : null;
			isset($_REQUEST["tmc_new"]["buh_dt"]) ? $_REQUEST["tmc_new"]["buh_dt"]=OraDate2MDBDate($_REQUEST["tmc_new"]["buh_dt"]) : null;
			Table_Update('tmc',$_REQUEST["tmc_new"],$_REQUEST["tmc_new"]);
		}
	}
}


if (!isset($_REQUEST["save"])&&!isset($_REQUEST["add"]))
{
	$params=array(':dpt_id' => $_SESSION["dpt_id"],':actual' => 0);
	$sql=rtrim(file_get_contents('sql/emp_exp_spd_list_by_dpt_id.sql'));
	$sql=stritr($sql,$params);
	$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('emp', $d);
	$smarty->display('tmc_uchet.html');
}

?>