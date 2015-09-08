<?

//ses_req();

audit("открыл os","os");

InitRequestVar("k");
InitRequestVar("d");

if ($_REQUEST["k"]["tn"]!=''&&$_REQUEST["k"]["y"]!='')
{
	$k = array('tn' => $_REQUEST["k"]["tn"],'y'=>$_REQUEST["k"]["y"]);
	Table_update("os_head",$k,$k);
}

if (isset($_REQUEST["save"]))
{
	isset($_REQUEST["d"]["data"]) ? $_REQUEST["d"]["data"]=OraDate2MDBDate($_REQUEST["d"]["data"]) : null;
	Table_update("os_head",$_REQUEST["k"],$_REQUEST["d"]);
	foreach ($_REQUEST["body"] as $k=>$v)
	{
		$table_name = "os_body";
		$keys = array('head_id'=>$_REQUEST["head_id"],'spr_id'=>$k);
       		Table_Update ($table_name, $keys, $v);
	}
	if (isset($_FILES["fn"]))
	{
	if ($_FILES["fn"]["name"]!='')
	{
		$d1="os_files/".$_REQUEST["head_id"];
		if (!file_exists($d1)) {mkdir($d1);}
		$fn=translit($_FILES["fn"]["name"]);
		//if ($_FILES["fn"]["error"][$k]==0){Table_Update("os_head",$_REQUEST["k"],array('fn'=>$fn));}
		if (is_uploaded_file($_FILES["fn"]['tmp_name'])){move_uploaded_file($_FILES["fn"]["tmp_name"], $d1."/".translit($_FILES["fn"]["name"]));}
	}
	}
}

if (isset($_REQUEST["del_file"]))
{
	unlink($_REQUEST["del_file"]);
}



$p = array(':tn' => $tn);
$sql = rtrim(file_get_contents('sql/os_dc.sql'));
$sql=stritr($sql,$p);


//echo $sql;

$r = &$db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$r ? $smarty->assign('os_dc', $r) : null;






$sql = rtrim(file_get_contents('sql/os_user_list.sql'));
//echo $sql;
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('os_user_list', $res);

$sql = rtrim(file_get_contents('sql/pos_list_actual.sql'));
//echo $sql;
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos_list_actual', $res);

$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);

$sql=rtrim(file_get_contents('sql/os_goal.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('os_goal', $data);

if ($_REQUEST["k"]["tn"]!=''&&$_REQUEST["k"]["y"]!='')

{



$sql = rtrim(file_get_contents('sql/os_head.sql'));
$p = array(':tn' => $_REQUEST["k"]["tn"],':y'=>$_REQUEST["k"]["y"]);
$sql=stritr($sql,$p);
//echo $sql;
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('os_head', $res);



//print_r($res);


$head_id=$res["id"];



//print_r($res);
//ses_req();
$sql = rtrim(file_get_contents('sql/os_body.sql'));
$p = array(':tn' => $_REQUEST["k"]["tn"],':y'=>$_REQUEST["k"]["y"]);
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('os_body', $res);
//print_r($res);
//ses_req();


$d1="os_files/".$head_id;
if (!file_exists($d1)) {mkdir($d1);}
$file_list=array();
if ($handle = opendir($d1)) {
	while (false !== ($file = readdir($handle)))
	{
		if ($file != "." && $file != "..") {$file_list[] = array("path"=>$d1,"file"=>$file);}
	}
	closedir($handle);
}
$smarty->assign("file_list", $file_list);



$parent_fio=$db->getOne("SELECT u.fio  FROM parents p, user_list u WHERE p.tn = ".$_REQUEST["k"]["tn"]." AND u.tn = p.parent");
$smarty->assign("parent_fio", $parent_fio);

$oplatakat=$db->getOne("SELECT oplatakat FROM user_list u WHERE u.tn = ".$_REQUEST["k"]["tn"]);
$smarty->assign("oplatakat", $oplatakat);

$p = array(
	':tn' => $_REQUEST["k"]["tn"],
	':event' => $_REQUEST["k"]["y"]-1
);

$sql = rtrim(file_get_contents('sql/os_ocenka_result.sql'));
$sql=stritr($sql,$p);
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ocenka_result', $res);

$sql = rtrim(file_get_contents('sql/os_ocenka_comm.sql'));
$sql=stritr($sql,$p);
$exp_comm = &$db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_comm', $exp_comm);

$sql = rtrim(file_get_contents('sql/os_tr.sql'));
$sql=stritr($sql,$p);
$tr = &$db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($tr as $k=>$v)
{
$sql = rtrim(file_get_contents('sql/os_tr_test.sql'));
$p[':head']=$v['id'];
$sql=stritr($sql,$p);
$ts = &$db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$tr[$k]['test']=$ts;
}

$smarty->assign('tr', $tr);

//print_r($tr);

}






$smarty->display('os.html');

?>