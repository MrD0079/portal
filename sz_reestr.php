<?

//audit ("������ ������ ��","sz");


InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
InitRequestVar("who",0);
InitRequestVar("status",0);
InitRequestVar("sz_cat",0);
InitRequestVar("executor",0);
InitRequestVar("creator",0);
InitRequestVar("country",$_SESSION["cnt_kod"]);
InitRequestVar("orderby",1);
InitRequestVar("sz_pos_id",0);
InitRequestVar("region_name","0");
InitRequestVar("department_name","0");
InitRequestVar("sz_id",0);
/*
if ($_REQUEST["sz_id"]=='')
{
	$_REQUEST["sz_id"]=0;
}
*/
//ses_req();

$params=array(':tn'=>$tn);

$sql=rtrim(file_get_contents('sql/sz_cat.sql'));
$sql=stritr($sql,$params);
$sz_cat = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('sz_cat', $sz_cat);

$sql = rtrim(file_get_contents('sql/sz_reestr_creators_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('creators_list', $data);

$sql = rtrim(file_get_contents('sql/sz_reestr_executors_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('executors_list', $data);

$sql = rtrim(file_get_contents('sql/sz_reestr_pos_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos_list', $data);

$sql = rtrim(file_get_contents('sql/sz_reestr_region_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('region_list', $data);

$sql = rtrim(file_get_contents('sql/sz_reestr_department_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('department_list', $data);

if (isset($_REQUEST["del_sz"]))
{
	$_REQUEST["select"]=1;
	if (isset($_REQUEST["del"]))
	{
		foreach($_REQUEST["del"] as $k=>$v)
		{
			Table_Update("sz",array("id"=>$v),null);
			audit ("������ �� �".$v,"sz");
		}
	}
}





if (isset($_REQUEST["save"]))
{
	//ses_req();
	$_REQUEST["select"]=1;
	if (isset($_REQUEST["d"]))
	{
		foreach($_REQUEST["d"] as $k=>$v)
		{
			if (!($v["valid_no"]==null))
			{
				Table_Update("sz",array("id"=>$k),$v);
				audit ("������ ��������������/���������������� �� �".$k,"sz");
			}
		}
	}
}


$params=array(
':tn' => $tn,
':dpt_id' => $_SESSION["dpt_id"],
":dates_list1"=>"'".$_REQUEST["dates_list1"]."'",
":dates_list2"=>"'".$_REQUEST["dates_list2"]."'",
":status"=>$_REQUEST["status"],
":sz_cat"=>$_REQUEST["sz_cat"],
":executor"=>$_REQUEST["executor"],
":creator"=>$_REQUEST["creator"],
":who"=>$_REQUEST["who"],
":orderby"=>$_REQUEST["orderby"],
":country"=>"'".$_REQUEST["country"]."'",
":sz_pos_id"=>$_REQUEST["sz_pos_id"],
":region_name"=>"'".$_REQUEST["region_name"]."'",
":department_name"=>"'".$_REQUEST["department_name"]."'",
":sz_id"=>$_REQUEST["sz_id"],
);

if ($_REQUEST["sz_id"]!=0)
{
	$params[":sz_id"]=$_REQUEST["sz_id"];
	$sql=rtrim(file_get_contents('sql/sz_reestr_find_sz.sql'));
	$sql=stritr($sql,$params);
	$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($data);
	if (isset($data))
	{
		$smarty->assign('find_sz', $data);
		$params[":dates_list1"]="'01.01.2000'";
		$params[":dates_list2"]="'31.12.2050'";
		$params[":who"]=0;
		$params[":status"]=0;
		$params[":sz_cat"]=0;
		$params[":executor"]=0;
		$params[":creator"]=0;
		$params[":country"]="'0'";
		$params[":orderby"]=1;
		$params[":sz_pos_id"]=0;
		$params[":region_name"]="0";
		$params[":department_name"]="0";
	}
}

if (isset($_REQUEST["select"]))
{

$sql=rtrim(file_get_contents('sql/sz_reestr.sql'));
$sql=stritr($sql,$params);
//echo $sql; exit;
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($data as $k=>$v)
{
$d[$v["id"]]["head"]=$v;
$d[$v["id"]]["executors"][$v["executor_tn"]]=$v;
$d[$v["id"]]["data"][$v["acceptor_tn"]]=$v;
if ($v["chat_id"]!="")
{
$d[$v["id"]]["chat"][$v["chat_id"]]=$v;
}
$d[$v["id"]]["files"][$v["fn"]]=$v;
}
isset($d) ? $smarty->assign('d', $d) : null;

$sql=rtrim(file_get_contents('sql/sz_reestr_total.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d1', $data);

}


$smarty->display('sz_reestr.html');



//ses_req();



?>