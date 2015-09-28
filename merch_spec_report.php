<?
//ses_req();
//audit("открыл merch_spec_report","merch_spec_report");
$sql="select * from merch_spec_head where id=".$_REQUEST["spec_id"];
$r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($r);
$smarty->assign('net_name', $db->getOne("select net_name from ms_nets where id_net=".$r["id_net"]));
$smarty->assign('ag_name', $db->getOne("select name from routes_agents where id=".$r["ag_id"]));
$smarty->assign('tz_name', $db->getOne("select distinct ur_tz_name from cpp where kodtp=".$r["kod_tp"]));
$smarty->assign('tz_address', $db->getOne("select distinct tz_address from cpp where kodtp=".$r["kod_tp"]));
$sql = rtrim(file_get_contents('sql/merch_spec_report_fields.sql'));
$p=array(":ag_id"=>$r["ag_id"]);
$sql=stritr($sql,$p);
//echo $sql;
$fields = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('merch_spec_report_fields', $fields);
//print_r($fields);

$sql = rtrim(file_get_contents('sql/merch_report_head.sql'));
$p=array(":data"=>"'".$_REQUEST["dt"]."'",":login"=>"'".$login."'");
$sql=stritr($sql,$p);
$h=$db->GetRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($h);

if (isset($_REQUEST["save"])||isset($_REQUEST["del_file"])||isset($_FILES["multiple_files"]))
{
	$keys = array(
		'head_id'=>$h["id"],
		'ag_id'=>$r["ag_id"],
		'kodtp'=>$r["kod_tp"],
		'data'=>OraDate2MDBDate($_REQUEST["dt"])
	);
	Table_Update ('MERCH_REPORT_CAL_SOK', $keys, $keys);
}

if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["rb"]))
	{
		//$oos_cnt=0;
		$table_name = "merch_spec_report";
		foreach ($_REQUEST["rb"] as $k => $v)
		{
			//echo $k."<br>";
			foreach ($v as $k1 => $v1)
			{
					//if (($k1=='oos')&&($v1==1)){$oos_cnt++;}
					//echo $k1."<br>";
					$keys = array('spec_id'=>$k,'dt'=>OraDate2MDBDate($_REQUEST["dt"]));
					$values = $keys;
					Table_Update ($table_name, $keys, $values);
					$values = array($k1=>$v1);
					/*echo $table_name."<br>";
					print_r($keys);
					echo "<br>";
					print_r($values);
					echo "<br>";*/
					Table_Update ($table_name, $keys, $values);
			}
		}
		//echo count($_REQUEST["rb"]).'.'.$oos_cnt;
	}
}
$d1="merch_spec_report_files";
$d2=$d1."/".$_REQUEST["dt"];
$d3=$d2."/".$r["ag_id"];
$d4=$d3."/".$r["kod_tp"];
if (isset($_REQUEST["del_file"]))
{
	unlink($_REQUEST["del_file"]);
	$path_parts = pathinfo($_REQUEST["del_file"]); 
	$keys = array("dt"=>OraDate2MDBDate($_REQUEST["dt"]),"ag_id"=>$r["ag_id"],"kod_tp"=>$r["kod_tp"],"fn"=>$path_parts["basename"]);
	Table_Update ("merch_spec_report_files", $keys, null);
}
if (!file_exists($d1)) {mkdir($d1);}
if (!file_exists($d2)) {mkdir($d2);}
if (!file_exists($d3)) {mkdir($d3);}
if (!file_exists($d4)) {mkdir($d4);}
include_once('SimpleImage.php');


if (isset($_REQUEST["rotate_file"]))
{
	$path_parts = pathinfo($_REQUEST["rotate_file"]); 
	$fn_new="msrf".get_new_file_id().".".$path_parts["extension"];
	$image = new SimpleImage();
	$image->load($_REQUEST["rotate_file"]);
	$image->rotate($_REQUEST["rotate_degrees"]);
	$image->save($d4."/".$fn_new);
	$keys = array("dt"=>OraDate2MDBDate($_REQUEST["dt"]),"ag_id"=>$r["ag_id"],"kod_tp"=>$r["kod_tp"],"fn"=>$path_parts["basename"]);
	//var_dump ($keys);
	Table_Update ("merch_spec_report_files", $keys, null);
	$keys = array("dt"=>OraDate2MDBDate($_REQUEST["dt"]),"ag_id"=>$r["ag_id"],"kod_tp"=>$r["kod_tp"],"fn"=>$fn_new);
	//var_dump ($keys);
	Table_Update ("merch_spec_report_files", $keys, $keys);
	unlink($_REQUEST["rotate_file"]);
	//var_dump ($fn_new);
	//ses_req();
}

if (isset($_FILES["multiple_files"]))
{
$z = $_FILES["multiple_files"];
foreach ($z['tmp_name'] as $k=>$v)
{
	if (is_uploaded_file($z["tmp_name"][$k]))
	{
		$a=pathinfo($z["name"][$k]);
		$fn="msrf".get_new_file_id().".".$a["extension"];
		move_uploaded_file($z["tmp_name"][$k], $d4."/".$fn);
		$image = new SimpleImage();
		$image->load($d4."/".$fn);
		//if (is_resource($image))
		//{
			$h=$image->getHeight();
			if ($image->getHeight()>600)
			{
			$image->resizeToHeight(600);
			//echo $fn.": ".$h."=>".$image->getHeight();
			}
			$image->save($d4."/".$fn);
		//}
		$keys = array("dt"=>OraDate2MDBDate($_REQUEST["dt"]),"ag_id"=>$r["ag_id"],"kod_tp"=>$r["kod_tp"],"fn"=>$fn);
		Table_Update ("merch_spec_report_files", $keys, $keys);
	}
}
}
$file_list=array();
if ($handle = opendir($d4)) {
	while (false !== ($file = readdir($handle)))
	{
		if ($file != "." && $file != "..") {$file_list[] = array("path"=>$d4,"file"=>$file);}
	}
	closedir($handle);
}
$smarty->assign("file_list", $file_list);
$sql = rtrim(file_get_contents('sql/merch_spec_report_body.sql'));
$p=array(":head_id"=>$r["id"],":dt"=>"'".$_REQUEST["dt"]."'");
$sql=stritr($sql,$p);
//echo $sql;
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('merch_spec_report_body', $res);
//print_r($res);
$sql = rtrim(file_get_contents('sql/merch_spec_report_body_total.sql'));
$p=array(":head_id"=>$r["id"],":dt"=>"'".$_REQUEST["dt"]."'");
$sql=stritr($sql,$p);
//echo $sql;
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('merch_spec_report_body_total', $res);
//print_r($res);
$smarty->display('merch_spec_report.html');
?>