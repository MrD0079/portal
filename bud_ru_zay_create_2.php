<?









//ini_set('display_errors', 'On');
$params = array();
if (isset($_REQUEST["id"]))
{
	$sql=rtrim(file_get_contents('sql/bud_ru_zay_get_head.sql'));
	$p=array(':z_id' => $_REQUEST["id"]);
	$sql=stritr($sql,$p);
	$z=$db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$params[":tn"]=$z["tn"];
	$params[":fil"]=$z["fil"];
	$params[":dpt_id"]=$z["dpt_id"];
	!isset($_REQUEST["save"])?$_REQUEST["new"]=$z:null;
	$sql=rtrim(file_get_contents('sql/bud_ru_zay_get_ff.sql'));
	$p=array(':z_id' => $_REQUEST["id"]);
	$sql=stritr($sql,$p);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($data as $k1=>$v1)
	{
		if ($v1["type"]=="file"&&$v1["val_file"]!="")
		{
			$data[$k1]["val_file"]=explode("\n",$v1["val_file"]);
		}
	}
	include "bud_ru_zay_formula.php";
	!isset($_REQUEST["save"])?$_REQUEST["edit_st"]=$data:null;

	$sql=rtrim(file_get_contents('sql/bud_ru_zay_edit_acceptors.sql'));
	$params[":id"]=$_REQUEST["id"];
	$sql=stritr($sql,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('bud_ru_zay_edit_acceptors', $data);

	$sql=rtrim(file_get_contents('sql/bud_ru_zay_edit_executors.sql'));
	$params[":id"]=$_REQUEST["id"];
	$sql=stritr($sql,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('bud_ru_zay_edit_executors', $data);

}
else
{
	$params[":dpt_id"]=$_SESSION["dpt_id"];
	$params[":tn"]=$tn;
	$params[":fil"]=$_REQUEST["new"]["fil"];
	$_REQUEST["new"]["tn"]=$tn;
	$_REQUEST["new"]["st"]=$db->getOne("SELECT parent FROM bud_ru_st_ras st WHERE id=".$_REQUEST["new"]["kat"]);
}

$sql="select * from user_list where tn=".$params[":tn"];
$me = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('me', $me);

if (isset($_REQUEST["save"]))
{
	if (!isset($_REQUEST["admin"]))
	{
		foreach ($_REQUEST["bud_ru_acceptors"] as $k=>$v)
		{
			if ($v!=null)
			{
				$_REQUEST["new"]["recipient"]=$v;
			}
		}
	}
	if (isset($_REQUEST["id"]))
	{
		$id = $_REQUEST["id"];
	}
	else
	{
		$id = get_new_id();
	}
	$keys = array("id"=>$id);
	isset($_REQUEST["new"]["dt_start"]) ? $_REQUEST["new"]["dt_start"]=OraDate2MDBDate($_REQUEST["new"]["dt_start"]) : null;
	isset($_REQUEST["new"]["dt_end"]) ? $_REQUEST["new"]["dt_end"]=OraDate2MDBDate($_REQUEST["new"]["dt_end"]) : null;
	Table_Update("bud_ru_zay",$keys,$_REQUEST["new"]);
	$keys = array("z_id"=>$id);
	if (!isset($_REQUEST["admin"]))
	{
		Table_Update("bud_ru_zay_accept",$keys,null);
		Table_Update("bud_ru_zay_executors",$keys,null);
		foreach ($_REQUEST["bud_ru_acceptors"] as $k=>$v)
		{
			$keys = array("z_id"=>$id,"tn"=>$v);
			if ($v!=null)
			{
				Table_Update("bud_ru_zay_accept",$keys,$keys);
			}
		}
		if (isset($_REQUEST["bud_ru_executors"]))
		{
			foreach ($_REQUEST["bud_ru_executors"] as $k=>$v)
			{
				$keys = array("z_id"=>$id,"tn"=>$v);
				if ($v!=null)
				{
					Table_Update("bud_ru_zay_executors",$keys,$keys);
				}
			}
		}
	}
	if (isset($_REQUEST["new_st"]))
	{
		foreach ($_REQUEST["new_st"] as $k=>$v)
		{
			$var_type = $db->getOne("select type from bud_ru_ff where id=".$k);
			$var_type=="datepicker"&&isset($v) ? $v=OraDate2MDBDate($_REQUEST["new_st"][$k]) : null;
			$keys = array("z_id"=>$id,"ff_id"=>$k);
			$vals = array("val_".$var_type=>$v);
			Table_Update("bud_ru_zay_ff",$keys,$vals);
		}
	}
	if (isset($_REQUEST["bud_ru_zay_files_del"]))
	{
		foreach ($_REQUEST["bud_ru_zay_files_del"] as $k=>$v)
		{
			$old_val=$db->getOne("select val_file from bud_ru_zay_ff where z_id=".$id." and ff_id=".$k);
			$ov=explode("\n",$old_val);
			$keys = array("z_id"=>$id,"ff_id"=>$k);
			$del_array=array();
			foreach ($v as $k1=>$v1)
			{
				unlink($v1);
				$del_array[]=$k1;
			}
			$vals = array("val_file"=>implode(array_diff($ov,$del_array),"\n"));
			Table_Update("bud_ru_zay_ff",$keys,$vals);
		}
	}
	if (isset($_FILES["new_st"]))
	{
		foreach ($_FILES["new_st"]["tmp_name"] as $k=>$v)
		{
			$old_val=$db->getOne("select val_file from bud_ru_zay_ff where z_id=".$id." and ff_id=".$k);
			isset($old_val)?$old_val="\n".$old_val:null;
			$s=array();
			foreach ($v as $k1=>$v1)
			{
			if (is_uploaded_file($v1))
			{
				$a=pathinfo($_FILES["new_st"]["name"][$k][$k1]);
				$fn=translit($_FILES["new_st"]["name"][$k][$k1]);
				$path="bud_ru_zay_files/".$id."/".$k;
				if (!file_exists($path)) {mkdir($path,0777,true);}
				move_uploaded_file($v1, $path."/".$fn);
				$s[]=$fn;
				$ss=implode($s,"\n");
				$keys = array("z_id"=>$id,"ff_id"=>$k);
				$vals = array("val_file"=>$ss.$old_val);
				Table_Update("bud_ru_zay_ff",$keys,$vals);
			}
			}
		}
	}

	$sql=rtrim(file_get_contents('sql/bud_ru_zay_create_get_acceptors.sql'));
	$params=array(":id"=>$id);
	$sql=stritr($sql,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('acceptors', $data);
}

$sql=rtrim(file_get_contents('sql/bud_ru_st_ras.sql'));
$sql=stritr($sql,$params);
$bud_ru_st_ras = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_ru_st_ras', $bud_ru_st_ras);

isset($_REQUEST["new"]['fil'])?$smarty->assign('fil_name', $db->getOne('select name from bud_fil where id='.$_REQUEST["new"]['fil'])):null;

$sql=rtrim(file_get_contents('sql/bud_funds.sql'));
$sql=stritr($sql,$params);
$funds = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('funds', $funds);

$sql=rtrim(file_get_contents('sql/bud_ru_zay_create_get_rm.sql'));
$sql=stritr($sql,$params);
$rm = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('rm', $rm);

if (!isset($_REQUEST["save"]))
{
	$params[':kat']=$_REQUEST["new"]["kat"];
	$sql=rtrim(file_get_contents('sql/bud_ru_zay_create_ff.sql'));
	$sql=stritr($sql,$params);
	$st = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($st as $k=>$v)
	{
		if ($v['type']=='list')
		{
			$sql=$db->getOne('select get_list from bud_ru_ff_subtypes where id='.$v['subtype']);
			$sql=stritr($sql,$params);
			$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$st[$k]['list'] = $list;
		}
		if ($v['parent_field']!==null&&$v['parent_field_val']!==null)
		{
			$linked_fields[$v['parent_field']][$v['id']]=$v;
		}
	}
	isset($linked_fields)?$smarty->assign('linked_fields', $linked_fields):null;
	$smarty->assign('st', $st);
}
//$_REQUEST["zzz"]=$st;
//ses_req();

$sql = rtrim(file_get_contents('sql/emp_exp_spd_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list', $data);

$sql=rtrim(file_get_contents('sql/bud_ru_zay_create_nets.sql'));
$sql=stritr($sql,$params);
$nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $nets);

$sql=rtrim(file_get_contents('sql/statya_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('statya_list', $data);

$sql=rtrim(file_get_contents('sql/payment_type.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('payment_type', $data);


$sql=rtrim(file_get_contents('sql/bud_ru_zay_create_getDisabledDates.sql'));
$sql=stritr($sql,$params);
$dd = $db->getOne($sql);
$smarty->assign('DisabledDates', $dd);

$smarty->display('bud_ru_zay_create_2.html');

?>