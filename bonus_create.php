<?

//InitRequestVar("v_from",$now);
//InitRequestVar("v_to",$now);
//audit ("открыл форму создания отпусков","bonus");

if (isset($_REQUEST["add"])&&isset($_REQUEST["head"])&&isset($_REQUEST["data"]))
{
	isset($_REQUEST["head"]["id"]) ? $id=$_REQUEST["head"]["id"] : $id=get_new_id();
	$_REQUEST["head"]["id"]=$id;
	$_REQUEST["head"]["tn"]=$tn;
	$_REQUEST["head"]["dpt_id"]=$_SESSION['dpt_id'];
	Table_Update("bonus_head",array('id'=>$id),$_REQUEST["head"]);
	Table_Update("bonus_body",array('bonus_id'=>$id),null);
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		$vals=$v;
		$vals["bonus_id"]=$id;
		$vals["id"]=$k;
		isset($vals["mz"]) ? $vals["mz"]=OraDate2MDBDate($vals["mz"]) : null;
		Table_Update("bonus_body",$vals,$vals);
	}
	
	if (isset($_FILES["files"]))
	foreach ($_FILES["files"]["name"] as $k=>$v)
	{
		if (is_uploaded_file($_FILES["files"]['tmp_name'][$k]))
		{
			$a=pathinfo($_FILES["files"]['name'][$k]);
			$fn="sz".get_new_file_id().".".$a["extension"];
			move_uploaded_file($_FILES["files"]['tmp_name'][$k], "files/".$fn);
			$keys = array("bonus_id"=>$id,"fn"=>$fn);
			Table_Update ("bonus_files", $keys, $keys);
		}
	}
	$db->query("BEGIN PR_bonus_SZ_CREATE (".$id."); END;");
}

if (isset($_REQUEST['id']))
{
$sql=rtrim(file_get_contents('sql/bonus_create_head.sql'));
$params=array(':id' => $_REQUEST['id']);
$sql=stritr($sql,$params);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bonus_h', $data);

$sql=rtrim(file_get_contents('sql/bonus_create_body.sql'));
$params=array(':id' => $_REQUEST['id']);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bonus_b', $data);
//print_r($data);

$sql=rtrim(file_get_contents('sql/bonus_create_files.sql'));
$params=array(':id' => $_REQUEST['id']);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bonus_f', $data);
}

$sql=rtrim(file_get_contents('sql/bonus_types_all.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bonus_types', $data);

$smarty->display('bonus_create.html');

?>