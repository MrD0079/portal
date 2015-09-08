<?

audit ("открыл реестр заявок на проведение АЦ","ac");


InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
InitRequestVar("who",0);
InitRequestVar("status",0);
InitRequestVar("ac_cat",0);
InitRequestVar("executor",0);
InitRequestVar("creator",0);
InitRequestVar("country",$_SESSION["cnt_kod"]);
InitRequestVar("orderby",1);
InitRequestVar("ac_pos_id",0);
InitRequestVar("region_name","0");
InitRequestVar("department_name","0");
InitRequestVar("ac_id",0);

//ses_req();



$params=array(':tn'=>$tn);

$sql=rtrim(file_get_contents('sql/ac_cat.sql'));
$sql=stritr($sql,$params);
$ac_cat = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ac_cat', $ac_cat);

$sql = rtrim(file_get_contents('sql/ac_reestr_creators_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('creators_list', $data);

$sql = rtrim(file_get_contents('sql/ac_reestr_executors_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('executors_list', $data);

$sql = rtrim(file_get_contents('sql/ac_reestr_pos_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos_list', $data);

$sql = rtrim(file_get_contents('sql/ac_reestr_region_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('region_list', $data);

$sql = rtrim(file_get_contents('sql/ac_reestr_department_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('department_list', $data);

$sql=rtrim(file_get_contents('sql/ac_accept_types.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('acat', $data);

if (isset($_REQUEST["del_ac"]))
{
	$_REQUEST["select"]=1;
	if (isset($_REQUEST["del"]))
	{
		foreach($_REQUEST["del"] as $k=>$v)
		{
			Table_Update("ac",array("id"=>$v),null);
			audit ("удалил заявку на проведение АЦ №".$v,"ac");
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
				Table_Update("ac",array("id"=>$k),$v);
				audit ("сделал действительной/недействительной заявку на проведение АЦ №".$k,"ac");
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
":ac_cat"=>$_REQUEST["ac_cat"],
":executor"=>$_REQUEST["executor"],
":creator"=>$_REQUEST["creator"],
":who"=>$_REQUEST["who"],
":orderby"=>$_REQUEST["orderby"],
":country"=>"'".$_REQUEST["country"]."'",
":ac_pos_id"=>$_REQUEST["ac_pos_id"],
":region_name"=>"'".$_REQUEST["region_name"]."'",
":department_name"=>"'".$_REQUEST["department_name"]."'",
);

if ($_REQUEST["ac_id"]!=0)
{
	$params[":ac_id"]=$_REQUEST["ac_id"];
	$sql=rtrim(file_get_contents('sql/ac_reestr_find_ac.sql'));
	$sql=stritr($sql,$params);
	$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	isset($data) ? $smarty->assign('find_ac', $data) : null;
	//print_array($data);
	if ($data["exist"]!=0&&$data["visible"]==1)
	{
		$sql=rtrim(file_get_contents('sql/ac_reestr_find_ac_show.sql'));
		$sql=stritr($sql,$params);
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
	}
}

if (isset($_REQUEST["select"])&&$_REQUEST["ac_id"]==0)
{

$sql=rtrim(file_get_contents('sql/ac_reestr.sql'));
$sql=stritr($sql,$params);
//echo $sql;
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

$sql=rtrim(file_get_contents('sql/ac_reestr_total.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d1', $data);

}


$smarty->display('ac_reestr.html');



//ses_req();



?>