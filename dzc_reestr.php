<?


InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
InitRequestVar("who",0);
InitRequestVar("status",0);
InitRequestVar("creator",0);
InitRequestVar("country",$_SESSION["cnt_kod"]);
InitRequestVar("orderby",1);
InitRequestVar("dzc_id",0);





$params=array(':tn'=>$tn);

$sql = rtrim(file_get_contents('sql/dzc_reestr_creators_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('creators_list', $data);

if (isset($_REQUEST["del_dzc"]))
{
	$_REQUEST["select"]=1;
	if (isset($_REQUEST["del"]))
	{
		foreach($_REQUEST["del"] as $k=>$v)
		{
			Table_Update("dzc",array("id"=>$v),null);
			audit ("удалил заявку на компенсацию дистрибутору №".$v,"dzc");
		}
	}
}





if (isset($_REQUEST["save"]))
{
	
	$_REQUEST["select"]=1;
	if (isset($_REQUEST["d"]))
	{
		foreach($_REQUEST["d"] as $k=>$v)
		{
			if (!($v["valid_no"]==null))
			{
				Table_Update("dzc",array("id"=>$k),$v);
				audit ("сделал действительной/недействительной заявку на компенсацию дистрибутору №".$k,"dzc");
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
":creator"=>$_REQUEST["creator"],
":who"=>$_REQUEST["who"],
":orderby"=>$_REQUEST["orderby"],
":country"=>"'".$_REQUEST["country"]."'",
":dzc_id"=>$_REQUEST["dzc_id"],
);

if ($_REQUEST["dzc_id"]!=0)
{
	$params[":dzc_id"]=$_REQUEST["dzc_id"];
	$sql=rtrim(file_get_contents('sql/dzc_reestr_find_dzc.sql'));
	$sql=stritr($sql,$params);
	$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($data);
	if (isset($data))
	{
		$smarty->assign('find_dzc', $data);
		$params[":dates_list1"]="'01.01.2000'";
		$params[":dates_list2"]="'31.12.2050'";
		$params[":who"]=0;
		$params[":status"]=0;
		$params[":dzc_cat"]=0;
		$params[":creator"]=0;
		$params[":country"]="'0'";
		$params[":orderby"]=1;
		$params[":dzc_pos_id"]=0;
		$params[":region_name"]="0";
		$params[":department_name"]="0";
	}
}

if (isset($_REQUEST["select"]))
{

$sql=rtrim(file_get_contents('sql/dzc_reestr.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($data as $k=>$v)
{
$d[$v["id"]]["head"]=$v;
$d[$v["id"]]["data"][$v["acceptor_tn"]]=$v;
$d[$v["id"]]["customers"][$v["customerid"]]=$v;
if ($v["chat_id"]!="")
{
$d[$v["id"]]["chat"][$v["chat_id"]]=$v;
}
$d[$v["id"]]["files"][$v["fn"]]=$v;
}
isset($d) ? $smarty->assign('d', $d) : null;

$sql=rtrim(file_get_contents('sql/dzc_reestr_total.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d1', $data);

}


$smarty->display('dzc_reestr.html');







?>