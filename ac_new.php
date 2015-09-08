<?

audit ("открыл форму создания/редактирования заявок на проведение АЦ","ac");

if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["id"]))
	{
		Table_Update("ac",array("id"=>$_REQUEST["id"]),$_REQUEST["ac"]);
		$id=$_REQUEST["id"];
		$keys = array("ac_id"=>$id);

		Table_Update("ac_accept",$keys,null);
		Table_Update("ac_comm",$keys,null);
		Table_Update("ac_memb_int",$keys,null);
		Table_Update("ac_memb_ext",$keys,null);

		audit ("сохранил заявку на проведение АЦ №".$id,"ac");
	}
	else
	{
		$id = get_new_id();
		$keys = array("id"=>$id);
		$_REQUEST["ac"]["dt"]=OraDate2MDBDate($_REQUEST["ac"]["dt"]);
		Table_Update("ac",$keys,$_REQUEST["ac"]);

		$keys = array("ac_id"=>$id,'tn'=>$parameters['vacation']['val_number']);
		Table_Update("ac_accept",$keys,$keys);

		$keys = array("ac_id"=>$id,'tn'=>2923402273);
		Table_Update("ac_accept",$keys,$keys);

		audit ("добавил заявку на проведение АЦ №".$id,"ac");
	}

	if (isset($_REQUEST["ac_comm"]))
	{
	foreach ($_REQUEST["ac_comm"] as $k=>$v)
	{
		$keys = array("ac_id"=>$id,"tn"=>$v);
		if ($v!=null)
		{
			Table_Update("ac_comm",$keys,$keys);
			audit ("добавил в заявку на проведение АЦ №".$id." ЧОК ".$v,"ac");
		}
	}
	}

	if (isset($_REQUEST["ac_memb_int"]))
	{
	foreach ($_REQUEST["ac_memb_int"] as $k=>$v)
	{
		$keys = array(
			"tn"=>$v["tn"],
			"ac_id"=>$id
		);
		$vals = array(
			"ac_test_logic"=>$v['ac_test_logic'],
			"ac_test_math"=>$v['ac_test_math'],
		);
		Table_Update("ac_memb_int",$keys,$vals);
		audit ("добавил в заявку на проведение АЦ №".$id." внутреннего кандидата №".$v["tn"],"ac");
	}
	}

	if (isset($_REQUEST["ac_memb_ext"]))
	{
	foreach ($_REQUEST["ac_memb_ext"] as $k=>$v)
	{
		$keys = array(
			"memb_ext_order"=>$k,
			"ac_id"=>$id
		);
		$fn=null;
		if (isset($_FILES['ac_memb_ext']['tmp_name'][$k]))
		{
			if (is_uploaded_file($_FILES['ac_memb_ext']['tmp_name'][$k]))
			{
				$a=pathinfo($_FILES['ac_memb_ext']["name"][$k]);
				$fn="ac".get_new_file_id().".".$a["extension"];
				move_uploaded_file($_FILES['ac_memb_ext']['tmp_name'][$k], "ac_files/".$fn);

				//$keys = array("memb_ext_order"=>$k,"ac_id"=>$id);
				//$vals = array("resume"=>$fn);
				//Table_Update ("ac_memb_ext", $keys, $vals);
				//audit ("добавил в заявку на проведение АЦ №".$id." файл №".$k." ".$fn,"ac");

			}
		}
		$vals = array(
			"fam"=>$v['fam'],
			"im"=>$v['im'],
			"otch"=>$v['otch'],
			"email"=>$v['email'],
			"ac_test_logic"=>$v['ac_test_logic'],
			"ac_test_math"=>$v['ac_test_math'],
			"resume"=>$fn
		);
		if ($v['fam']!=null)
		{
			Table_Update("ac_memb_ext",$keys,$vals);
			audit ("добавил в заявку на проведение АЦ №".$id." внешнего кандидата №".$k." ".$v['fam']." ".$v['im']." ".$v['otch'],"ac");
		}
	}
	}

/*
	if (isset($_FILES['ac_memb_ext']))
	{
		foreach ($_FILES['ac_memb_ext']['tmp_name'] as $k=>$v)
		{
			if (is_uploaded_file($v))
			{
				$a=pathinfo($_FILES['ac_memb_ext']["name"][$k]);
				$fn="ac".get_new_file_id().".".$a["extension"];
				move_uploaded_file($v, "ac_files/".$fn);
				$keys = array("memb_ext_order"=>$k,"ac_id"=>$id);
				$vals = array("resume"=>$fn);
				Table_Update ("ac_memb_ext", $keys, $vals);
				audit ("добавил в заявку на проведение АЦ №".$id." файл №".$k." ".$fn,"ac");
			}
		}
	}
*/
	$sql=rtrim(file_get_contents('sql/ac_acceptors.sql'));
	$params=array(":id"=>$id);
	$sql=stritr($sql,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('acceptors', $data);

	$data = $db->getAll("SELECT * FROM full_log WHERE prg = 'ac' AND text LIKE '%№".$id."%' ORDER BY id", null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('result', $data);
}

if (isset($_REQUEST["id"]))
{
	$sql=rtrim(file_get_contents('sql/ac_edit_head.sql'));
	$params=array(':id'=>$_REQUEST["id"]);
	$sql=stritr($sql,$params);
	$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$_REQUEST["ac"]=$data;

	$sql=rtrim(file_get_contents('sql/ac_edit_comm.sql'));
	$params=array(':id'=>$_REQUEST["id"]);
	$sql=stritr($sql,$params);
	$data = $db->getAssoc($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$_REQUEST["ac_comm"]=$data;

	$sql=rtrim(file_get_contents('sql/ac_edit_memb_int.sql'));
	$params=array(':id'=>$_REQUEST["id"]);
	$sql=stritr($sql,$params);
	$data = $db->getAssoc($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$_REQUEST["ac_memb_int"]=$data;

/*
	if (isset($_REQUEST["ac_files_del"]))
	{
		foreach ($_REQUEST["ac_files_del"] as $k=>$v)
		{
			unlink("ac_files/".$v);
			Table_Update("ac_files",array("fn"=>$v),null);
			audit ("удалил из заявки на проведение АЦ №".$_REQUEST["id"]." файл ".$v,"ac");

		}
	}

	$sql=rtrim(file_get_contents('sql/ac_edit_files.sql'));
	$params=array(':id'=>$_REQUEST["id"]);
	$sql=stritr($sql,$params);
	$data = $db->getAssoc($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$_REQUEST["ac_files"]=$data;
*/
}
else
{
	$_REQUEST["ac"]["tn"]=$tn;
}

$params = array();

if (isset($_REQUEST["ac"]))
{
$params[':tn'] = $_REQUEST["ac"]["tn"];
}
else
{
$params[':tn'] = $tn;
}

$params[':dpt_id'] = $db->getOne("select dpt_id from user_list where tn=".$params[':tn']);

$sql = rtrim(file_get_contents('sql/emp_exp_spd_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list', $data);

$sql=rtrim(file_get_contents('sql/pos_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos_list', $data);

$p = array(":id" => 0);
$sql = rtrim(file_get_contents('sql/ac_test.sql'));
$sql=stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ac_test', $r);

$smarty->display('ac_new.html');

?>