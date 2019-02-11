<?
$_REQUEST["tu"]==1?$doc_str="цели на переговоры":$doc_str="заявка на проведение активности";
$dyn_flt='';
if (isset($_REQUEST["dyn_flt"]))
{
	$a1=array();
	foreach ($_REQUEST["dyn_flt"] as $k=>$v)
	{
		($v["subtype"]!=null)&&($v["item"]!=null)?$a1[]=$v["item"]:null;
	}
	(count($a1)>0)?$dyn_flt='AND bud_ru_zay.id IN (SELECT z_id FROM bud_ru_zay_ff WHERE val_list IN ('.join($a1,',').') HAVING COUNT (*) = '.count($a1).' GROUP BY z_id)':$dyn_flt='';
	
	//print_r($dyn_flt);
}

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
InitRequestVar("who",0);
InitRequestVar("report_data",0);
InitRequestVar("status",0);
InitRequestVar("st",0);
InitRequestVar("kat",0);
InitRequestVar("creator",0);
InitRequestVar("country",$_SESSION["cnt_kod"]);
InitRequestVar("orderby",1);
InitRequestVar("r_pos_id",0);
InitRequestVar("fil",0);
InitRequestVar("funds",0);
InitRequestVar("id_net",0);
InitRequestVar("region_name","0");
InitRequestVar("department_name","0");
InitRequestVar("z_id",0);
InitRequestVar("date_between_brzr","dt12");

$dev_req = isset($_REQUEST['dev']) ? $_REQUEST['dev'] : 0;
InitRequestVar("dev",$dev_req);




$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

$sql=rtrim(file_get_contents('sql/bud_ru_st_ras.sql'));
$sql=stritr($sql,$params);
$st = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('st', $st);

$sql = rtrim(file_get_contents('sql/bud_ru_zay_reestr_creators_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('creators_list', $data);

$sql = rtrim(file_get_contents('sql/bud_ru_zay_reestr_pos_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos_list', $data);

$sql = rtrim(file_get_contents('sql/bud_ru_zay_reestr_region_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('region_list', $data);

$sql = rtrim(file_get_contents('sql/bud_ru_zay_reestr_fil_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('fil_list', $data);

$sql = rtrim(file_get_contents('sql/bud_ru_zay_reestr_funds_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('funds_list', $data);

$sql=rtrim(file_get_contents('sql/nets.sql'));
$sql=stritr($sql,$params);
$nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $nets);

$sql = rtrim(file_get_contents('sql/bud_ru_zay_reestr_department_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('department_list', $data);

if (isset($_REQUEST["del_bud_ru_zay"]))
{
	$_REQUEST["select"]=1;
	if (isset($_REQUEST["del"]))
	{
		foreach($_REQUEST["del"] as $k=>$v)
		{
			Table_Update("bud_ru_zay",array("id"=>$v),null);
		}
	}
}

if (isset($_REQUEST["reset"])&&isset($_REQUEST["reset_z_id"]))
{
	$_REQUEST["select"]=1;
	$db->query("update bud_ru_zay_accept set accepted=0 where z_id=".$_REQUEST["reset_z_id"]);
	$db->query("delete from nets_plan_month where bud_z_id=".$_REQUEST["reset_z_id"]." and plan_type=3");
}

if (isset($_REQUEST["save"]))
{

	$_REQUEST["select"]=1;
// 5. В ВИДЕ ИСКЛЮЧЕНИЯ:
// на всех заявках (согласованных и в процессе согласования) дать возможность ДБ выставить клиентов из выпадающего списка в поле "Клиент",
// у которого будет выставлен тип "Выпадающий список-КЛИЕНТЫ". 
	if (isset($_REQUEST["new_st"]))
	{
		foreach ($_REQUEST["new_st"] as $k=>$v)
		{
			$var_type = $db->getOne("SELECT TYPE FROM bud_ru_ff WHERE id = (SELECT ff_id FROM bud_ru_zay_ff WHERE id = ".$k.")");
			$keys = array("id"=>$k);
			$vals = array("val_".$var_type=>$v);
			Table_Update("bud_ru_zay_ff",$keys,$vals);
		}

	}
// 5. В ВИДЕ ИСКЛЮЧЕНИЯ:
// на всех заявках (согласованных и в процессе согласования) дать возможность ДБ выставить клиентов из выпадающего списка в поле "Клиент",
// у которого будет выставлен тип "Выпадающий список-КЛИЕНТЫ". 

	if (isset($_REQUEST["d"]))
	{
		foreach($_REQUEST["d"] as $k=>$v)
		{
			isset($v["report_data"]) ? $v["report_data"]=OraDate2MDBDate($v["report_data"]) : null;
			Table_Update("bud_ru_zay",array("id"=>$k),$v);
		}
	}
}


$params=array(
':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
':tn' => $tn,
':dpt_id' => $_SESSION["dpt_id"],
":dates_list1"=>"'".$_REQUEST["dates_list1"]."'",
":dates_list2"=>"'".$_REQUEST["dates_list2"]."'",
":status"=>$_REQUEST["status"],
":st"=>$_REQUEST["st"],
":kat"=>$_REQUEST["kat"],
":creator"=>$_REQUEST["creator"],
":who"=>$_REQUEST["who"],
":report_data"=>$_REQUEST["report_data"],
":fil"=>$_REQUEST["fil"],
":funds"=>$_REQUEST["funds"],
":id_net"=>$_REQUEST["id_net"],
":orderby"=>$_REQUEST["orderby"],
":country"=>"'".$_REQUEST["country"]."'",
":r_pos_id"=>$_REQUEST["r_pos_id"],
":region_name"=>"'".$_REQUEST["region_name"]."'",
":department_name"=>"'".$_REQUEST["department_name"]."'",
"/*dyn_flt*/"=>$dyn_flt,
":z_id"=>$_REQUEST["z_id"],
':date_between_brzr' => "'".$_REQUEST["date_between_brzr"]."'",
':tu'=>$_REQUEST['tu']
);



if ($_REQUEST["z_id"]!=0)
{
	$params[":z_id"]=$_REQUEST["z_id"];
	$sql=rtrim(file_get_contents('sql/bud_ru_zay_reestr_find_z.sql'));
	$sql=stritr($sql,$params);
	$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	if (isset($data))
	{
		$smarty->assign('find_bud_ru_zay', $data);
		$params[":dates_list1"]="'01.01.2000'";
		$params[":dates_list2"]="'31.12.2050'";
		$params[":who"]=0;
		$params[":report_data"]=0;
		$params[":status"]=0;
		$params[":st"]=0;
		$params[":kat"]=0;
		$params[":creator"]=0;
		$params[":country"]="0"/*"'".$_SESSION["cnt_kod"]."'"*/;
		$params[":orderby"]=1;
		$params[":r_pos_id"]=0;
		$params[":fil"]=0;
		$params[":funds"]=0;
		$params[":id_net"]=0;
		$params[":region_name"]="0";
		$params[":department_name"]="0";
		$params[":tu"]=$_REQUEST["tu"];
		
	}
}

if (isset($_REQUEST["select"])&&(!isset($_REQUEST["showonlysvod"])))
{

    $sql=rtrim(file_get_contents('sql/bud_ru_zay_reestr.sql'));
    $sql=stritr($sql,$params);

    //$_REQUEST["SQL"]=$sql;

    //exit;

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
    }

if (isset($d))
{

foreach ($d as $k=>$v)
{
	$sql=rtrim(file_get_contents('sql/bud_ru_zay_get_ff.sql'));
	$p=array(':z_id' => $k);
	$sql=stritr($sql,$p);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

	//fix. Check is set any TP for local akciya
    $sql_tp="SELECT count(tp_kod) count_tp, SUM(bonus_sum) total_summ FROM akcii_local_tp WHERE z_id = ".$k;
    $data_tp = $db->getAll($sql_tp, null, null, null, MDB2_FETCHMODE_ASSOC);
    $d[$k]["local_tp"]=$data_tp[0];

	foreach ($data as $k1=>$v1)
	{
		if ($v1["type"]=="file")
		{
			$data[$k1]["val_file"]=explode("\n",$v1["val_file"]);
		}
		/*if ($v1['type']=='list')
		{
			if ($v1['val_list'])
			{
			$sql=$db->getOne('SELECT get_item FROM bud_ru_ff_subtypes WHERE id = (SELECT subtype FROM bud_ru_ff WHERE id = '.$v1['ff_id'].')');
			$params[':id'] = $v1['val_list'];
			$sql=stritr($sql,$params);
			$list = $db->getOne($sql);
			$data[$k1]['val_list_name'] = $list;
			}
		}*/
		// 5. В ВИДЕ ИСКЛЮЧЕНИЯ:
		// на всех заявках (согласованных и в процессе согласования) дать возможность ДБ выставить клиентов из выпадающего списка в поле "Клиент",
		// у которого будет выставлен тип "Выпадающий список-КЛИЕНТЫ". 
		/*if ($v1['type']=='list')
		{
			$sql=$db->getOne('select get_list from bud_ru_ff_subtypes where id = (SELECT subtype FROM bud_ru_ff WHERE id = '.$v1['ff_id'].')');
			$p=array(':tn'=>$d[$k]['head']['creator_tn']);
			$sql=stritr($sql,$p);
			//echo "<p>".$sql."</p>";
			$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$data[$k1]['list'] = $list;
		}*/
		// 5. В ВИДЕ ИСКЛЮЧЕНИЯ:
		// на всех заявках (согласованных и в процессе согласования) дать возможность ДБ выставить клиентов из выпадающего списка в поле "Клиент",
		// у которого будет выставлен тип "Выпадающий список-КЛИЕНТЫ". 
	}
	include "bud_ru_zay_formula.php";
	$d[$k]["ff"]=$data;
	//unset($data);
}
}

isset($d) ? $smarty->assign('d', $d) : null;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_reestr_total.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d1', $data);
//print_r($data);

}

if (isset($_REQUEST["select"]))
{

//$params[":status"]=1;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_reestr_ff.sql'));
$sql=stritr($sql,$params);
$bud_ru_ff = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_ru_ff', $bud_ru_ff);

$sql=rtrim(file_get_contents('sql/bud_ru_zay_reestr_ff_st_ras.sql'));
$sql=stritr($sql,$params);
$bud_ru_ff_st_ras = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_ru_ff_st_ras', $bud_ru_ff_st_ras);

$sql=rtrim(file_get_contents('sql/bud_ru_zay_reestr_ff_st.sql'));
$sql=stritr($sql,$params);
$bud_ru_ff_st = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_ru_ff_st', $bud_ru_ff_st);

}
include "SkuSelect.php";
$skuObj = new \SkuSelect\SkuSelect($db);
$smarty->assign('skuObj', $skuObj);

$smarty->display('bud_ru_zay_reestr.html');

?>