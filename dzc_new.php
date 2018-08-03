<?

audit ("открыл форму создания/редактирования заявки на компенсацию дистрибутору","dzc");


if (isset($_REQUEST["debug"]))
{

//exit;
}


if (isset($_REQUEST["save"]))
{
	isset($_REQUEST["dzc"]["dt"]) ? $_REQUEST["dzc"]["dt"]=OraDate2MDBDate($_REQUEST["dzc"]["dt"]) : null;
	foreach ($_REQUEST["dzc_acceptors"] as $k=>$v)
	{
		if ($v!=null)
		{
			$_REQUEST["dzc"]["recipient"]=$v;
		}
	}
	if (isset($_REQUEST["id"]))
	{
		Table_Update("dzc",array("id"=>$_REQUEST["id"]),$_REQUEST["dzc"]);
		$id=$_REQUEST["id"];
		$keys = array("dzc_id"=>$id);
		Table_Update("dzc_accept",$keys,null);
		audit ("сохранил заявку на компенсацию дистрибутору №".$id,"dzc");
	}
	else
	{
		$id = get_new_id();
		$keys = array("id"=>$id);
		if (trim( $_REQUEST["dzc"]["comm"])=="")
		{
			$_REQUEST["dzc"]["comm"]="Комментарии не заполнены";
		}
		Table_Update("dzc",$keys,$_REQUEST["dzc"]);
		audit ("добавил заявку на компенсацию дистрибутору №".$id,"dzc");
	}

//	echo "***".$id."***";

	foreach ($_REQUEST["dzc_acceptors"] as $k=>$v)
	{
		$keys = array("dzc_id"=>$id,"tn"=>$v);
		if ($v!=null)
		{
			Table_Update("dzc_accept",$keys,$keys);
			audit ("добавил в заявку на компенсацию дистрибутору №".$id." согласователя ".$v,"dzc");
		}
	}

	$sql=rtrim(file_get_contents('sql/dzc_acceptors.sql'));
	$params=array(":id"=>$id);
	$sql=stritr($sql,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('acceptors', $data);

	foreach ($_REQUEST["customers"] as $k=>$v)
	{
		$vals=$v;
		$vals["dzc_id"]=$id;
		$vals["id"]=$k;
		//isset($vals["mz"]) ? $vals["mz"]=OraDate2MDBDate($vals["mz"]) : null;
		Table_Update("dzc_customers",$vals,$vals);
	}

	if (isset($_FILES))
	{
		foreach ($_FILES as $k=>$v)
		{
			if (is_uploaded_file($v['tmp_name']))
			{
				$a=pathinfo($v["name"]);
				$fn="dzc".get_new_file_id().".".$a["extension"];
				move_uploaded_file($v["tmp_name"], "files/".$fn);
				$keys = array("dzc_id"=>$id,"fn"=>$fn);
				Table_Update ("dzc_files", $keys, $keys);
				audit ("добавил в заявку на компенсацию дистрибутору №".$id." файл ".$fn,"dzc");
			}
		}
	}
}

if (isset($_REQUEST["id"]))
{
	$sql=rtrim(file_get_contents('sql/dzc_edit_head.sql'));
	$params=array(':id'=>$_REQUEST["id"]);
	$sql=stritr($sql,$params);
	$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$_REQUEST["dzc"]=$data;

	$sql=rtrim(file_get_contents('sql/dzc_edit_acceptors.sql'));
	$params=array(':id'=>$_REQUEST["id"]);
	$sql=stritr($sql,$params);
	$data = $db->getAssoc($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$_REQUEST["dzc_acceptors"]=$data;

	$sql=rtrim(file_get_contents('sql/dzc_edit_customers.sql'));
	$params=array(':id'=>$_REQUEST["id"]);
	$sql=stritr($sql,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$_REQUEST["dzc_customers"]=$data;



	if (isset($_REQUEST["files_del"]))
	{
		foreach ($_REQUEST["files_del"] as $k=>$v)
		{
			unlink("files/".$v);
			Table_Update("dzc_files",array("fn"=>$v),null);
			audit ("удалил из заявки на компенсацию дистрибутору №".$_REQUEST["id"]." файл ".$v,"dzc");

		}
	}

	$sql=rtrim(file_get_contents('sql/dzc_edit_files.sql'));
	$params=array(':id'=>$_REQUEST["id"]);
	$sql=stritr($sql,$params);
	$data = $db->getAssoc($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$_REQUEST["files"]=$data;
}
else
{
	$_REQUEST["dzc"]["tn"]=$tn;
}


if (isset($_REQUEST["debug"]))
{

}






$params = array();

if (isset($_REQUEST["dzc"]))
{
$params[':tn'] = $_REQUEST["dzc"]["tn"];
//$params[':dpt_id'] = $_REQUEST["dzc"]["dpt_id"];
}
else
{
$params[':tn'] = $tn;
//$params[':dpt_id'] = $_SESSION["dpt_id"];
}

$params[':dpt_id'] = $db->getOne("select dpt_id from user_list where tn=".$params[':tn']);

$sql = rtrim(file_get_contents('sql/emp_exp_spd_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list', $data);

$ref = [
'currency',
'customers',
'departments',
'producttypes',
'statesofexpences',
];
foreach ($ref as $v)
{
	$smarty->assign('dzc_ref'.$v, $db->getAll(rtrim(file_get_contents('sql/dzc_ref'.$v.'.sql')), null, null, null, MDB2_FETCHMODE_ASSOC));
	//print_r($db->getAll(rtrim(file_get_contents('sql/dzc_ref'.$v.'.sql')), null, null, null, MDB2_FETCHMODE_ASSOC));
}

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$smarty->display('dzc_new.html');

?>