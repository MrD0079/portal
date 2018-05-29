<?
if (isset($_REQUEST["add"])&&isset($_REQUEST["head"])&&isset($_REQUEST["data"]))
{
	isset($_REQUEST["head"]["id"]) ? $id=$_REQUEST["head"]["id"] : $id=get_new_id();
	isset($_REQUEST["head"]["birthday"]) ? $_REQUEST["head"]["birthday"]=OraDate2MDBDate($_REQUEST["head"]["birthday"]) : null;
	isset($_REQUEST["head"]["planned_start"]) ? $_REQUEST["head"]["planned_start"]=OraDate2MDBDate($_REQUEST["head"]["planned_start"]) : null;
	isset($_REQUEST["head"]["prob_period_start"]) ? $_REQUEST["head"]["prob_period_start"]=OraDate2MDBDate($_REQUEST["head"]["prob_period_start"]) : null;
	isset($_REQUEST["head"]["prob_period_end"]) ? $_REQUEST["head"]["prob_period_end"]=OraDate2MDBDate($_REQUEST["head"]["prob_period_end"]) : null;
	$_REQUEST["head"]["id"]=$id;
	$_REQUEST["head"]["tn"]=$tn;
	$_REQUEST["head"]["dpt_id"]=$_SESSION['dpt_id'];
	if (isset($_FILES['resume']))
	{
		$d1="files/iv_files";
		if (!file_exists($d1)) {mkdir($d1,0777,true);}
		if (is_uploaded_file($_FILES["resume"]['tmp_name']))
		{
			$fn=get_new_file_id().'_'.translit($_FILES["resume"]["name"]);
			move_uploaded_file($_FILES["resume"]["tmp_name"], $d1."/".$fn);
			$_REQUEST["head"]["resume"]=$fn;
		}
	}
	Table_Update("iv_head",array('id'=>$id),$_REQUEST["head"]);
	Table_Update("iv_body",array('iid'=>$id),null);
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		$vals=$v;
		$vals["iid"]=$id;
		$vals["id"]=$k;
		Table_Update("iv_body",$vals,$vals);
	}
}
if (isset($_REQUEST["save"])&&isset($_REQUEST["head"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		$keys=array("id"=>$k);
		Table_Update("iv_body",$keys,$v);
	}
}

if (isset($_REQUEST['id']))
{
$sql=rtrim(file_get_contents('sql/iv_create_head.sql'));
$params=array(':id' => $_REQUEST['id']);
$sql=stritr($sql,$params);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('iv_h', $data);

$sql=rtrim(file_get_contents('sql/iv_create_body.sql'));
$params=array(':id' => $_REQUEST['id']);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('iv_b', $data);
}

$sql=rtrim(file_get_contents('sql/iv_create_list.sql'));
$params=array(':tn' => $tn, ':dpt_id' => $_SESSION['dpt_id']);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $data);

$sql = rtrim(file_get_contents('sql/pos_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos_list', $data);

$smarty->display('iv_create.html');

?>