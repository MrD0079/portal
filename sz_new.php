<?

//audit ("������ ����� ��������/�������������� ��","sz");


if (isset($_REQUEST["debug"]))
{

//exit;
}


if (isset($_REQUEST["save"]))
{
	foreach ($_REQUEST["sz_acceptors"] as $k=>$v)
	{
		if ($v!=null)
		{
			$_REQUEST["sz"]["recipient"]=$v;
		}
	}
	if (isset($_REQUEST["id"]))
	{

		Table_Update("sz",array("id"=>$_REQUEST["id"]),$_REQUEST["sz"]);
		$id=$_REQUEST["id"];

        //add chat with rejection detail

        $sql_acc = 'SELECT accepted FROM sz_accept WHERE sz_id=' . $id.' ORDER BY lu desc';
        $accepted = $db->getCol($sql_acc);
        if (is_array($accepted) && count($accepted) > 0) {
//            if sz rejected
            if ($accepted[0] == 2) {
                $sql_text = "SELECT p.param_name, p.val_string FROM PARAMETERS p where dpt_id=" . $_SESSION["dpt_id"] . " and p.param_name = 'sz_message_after_resubmission'";
                $reject_data = $db->getAll($sql_text, null, null, null, MDB2_FETCHMODE_ASSOC);
                if (is_array($reject_data) && count($reject_data) > 0) {
                    $reject_text = $reject_data[0]['val_string'];
                } else {
                    $reject_text = '����� ���� ������������ ����� ����������.';
                }
                $keys_reject = array(
                    "tn" => 1111111111, // �������
                    "sz_id" => $id,
                    "text" => $reject_text);
                Table_Update("sz_chat", $keys_reject, $keys_reject);
            }
        }

		$keys = array("sz_id"=>$id);
		Table_Update("sz_accept",$keys,null); //delete all status history
		Table_Update("sz_executors",$keys,null); //delete all ispolniteli
		audit ("�������� �� �".$id,"sz");


	}
	else
	{
		$id = get_new_id();
		$keys = array("id"=>$id);
		if (trim( $_REQUEST["sz"]["head"])=="")
		{
			$_REQUEST["sz"]["head"]="���� �� �� ���������";
		}
		if (trim( $_REQUEST["sz"]["body"])=="")
		{
			$_REQUEST["sz"]["body"]="���������� �� �� ���������";
		}
		Table_Update("sz",$keys,$_REQUEST["sz"]);
		audit ("������� �� �".$id,"sz");
	}

//	echo "***".$id."***";

	foreach ($_REQUEST["sz_acceptors"] as $k=>$v)
	{
		$keys = array("sz_id"=>$id,"tn"=>$v);
		if ($v!=null)
		{
			Table_Update("sz_accept",$keys,$keys);
			//audit ("������� � �� �".$id." ������������� ".$v,"sz");
		}
	}
	audit ("������� � �� �".$id." �������������� ".serialize($_REQUEST["sz_acceptors"]),"sz");
	
	if (isset($_REQUEST["sz_executors"]))
	{
		foreach ($_REQUEST["sz_executors"] as $k=>$v)
		{
			$keys = array("sz_id"=>$id,"tn"=>$v);
			if ($v!=null)
			{
				Table_Update("sz_executors",$keys,$keys);
				//audit ("������� � �� �".$id." ����������� ".$v,"sz");
			}
		}
		audit ("������� � �� �".$id." ������������ ".serialize($_REQUEST["sz_executors"]),"sz");
	}

	$sql=rtrim(file_get_contents('sql/sz_acceptors.sql'));
	$params=array(":id"=>$id);
	$sql=stritr($sql,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('acceptors', $data);


	if (isset($_FILES))
	{
		$files=array();
		foreach ($_FILES as $k=>$v)
		{
			if (is_uploaded_file($v['tmp_name']))
			{
				$a=pathinfo($v["name"]);
				$fn="sz".get_new_file_id().".".$a["extension"];
				move_uploaded_file($v["tmp_name"], "files/".$fn);
				$keys = array("sz_id"=>$id,"fn"=>$fn);
				$files[]=$fn;
				Table_Update ("sz_files", $keys, $keys);
				//audit ("������� � �� �".$id." ���� ".$fn,"sz");
			}
		}
		audit ("������� � �� �".$id." ����� ".serialize($files),"sz");
	}
}

if (isset($_REQUEST["id"]))
{
	$sql=rtrim(file_get_contents('sql/sz_edit_head.sql'));
	$params=array(':id'=>$_REQUEST["id"]);
	$sql=stritr($sql,$params);
	$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$_REQUEST["sz"]=$data;

	$sql=rtrim(file_get_contents('sql/sz_edit_acceptors.sql'));
	$params=array(':id'=>$_REQUEST["id"]);
	$sql=stritr($sql,$params);
	$data = $db->getAssoc($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$_REQUEST["sz_acceptors"]=$data;

	$sql=rtrim(file_get_contents('sql/sz_edit_executors.sql'));
	$params=array(':id'=>$_REQUEST["id"]);
	$sql=stritr($sql,$params);
	$data = $db->getAssoc($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$_REQUEST["sz_executors"]=$data;

	if (isset($_REQUEST["sz_files_del"]))
	{
		foreach ($_REQUEST["sz_files_del"] as $k=>$v)
		{
			unlink("files/".$v);
			Table_Update("sz_files",array("fn"=>$v),null);
			audit ("������ �� �� �".$_REQUEST["id"]." ���� ".$v,"sz");

		}
	}

	$sql=rtrim(file_get_contents('sql/sz_edit_files.sql'));
	$params=array(':id'=>$_REQUEST["id"]);
	$sql=stritr($sql,$params);
	$data = $db->getAssoc($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$_REQUEST["sz_files"]=$data;

}
else
{
	$_REQUEST["sz"]["tn"]=$tn;
}


if (isset($_REQUEST["debug"]))
{

}






$params = array();

if (isset($_REQUEST["sz"]))
{
$params[':tn'] = $_REQUEST["sz"]["tn"];
//$params[':dpt_id'] = $_REQUEST["sz"]["dpt_id"];
}
else
{
$params[':tn'] = $tn;
//$params[':dpt_id'] = $_SESSION["dpt_id"];
}

$params[':dpt_id'] = $db->getOne("select dpt_id from user_list where tn=".$params[':tn']);


$sql=rtrim(file_get_contents('sql/sz_parents.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('parents', $data);

/*
$sql=rtrim(file_get_contents('sql/sz_childs.sql'));
$params=array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('childs', $data);
*/

$sql=rtrim(file_get_contents('sql/sz_tpl.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('sz_tpl', $data);

$sql = rtrim(file_get_contents('sql/emp_exp_spd_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list', $data);

$sql=rtrim(file_get_contents('sql/sz_cat.sql'));
$sz_cat = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('sz_cat', $sz_cat);

$smarty->display('sz_new.html');

?>