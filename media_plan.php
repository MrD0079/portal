<?
audit("открыл media_plan","media_plan");

InitRequestVar("calendar_years");
InitRequestVar("plan_month");
InitRequestVar("tn_rmkk");
InitRequestVar("tn_mkk");
InitRequestVar("byyear",0);
InitRequestVar("nets",0);
InitRequestVar("statya_list_media_plan",null,true);
InitRequestVar("detalisation",0);
InitRequestVar("mgroups",1);

$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=rtrim(file_get_contents('sql/list_mkk_all.sql'));
$sql=stritr($sql,$params);
$list_mkk_all = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk_all', $list_mkk_all);
$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);
$sql=rtrim(file_get_contents('sql/calendar_months.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_months', $data);
$sql=rtrim(file_get_contents('sql/list_rmkk.sql'));
$sql=stritr($sql,$params);
$list_rmkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_rmkk', $list_rmkk);
$sql=rtrim(file_get_contents('sql/list_mkk.sql'));
$sql=stritr($sql,$params);
$list_mkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk', $list_mkk);
$sql=rtrim(file_get_contents('sql/nets.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);
$sql = rtrim(file_get_contents('sql/emp_exp_spd_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list', $data);
$sql=rtrim(file_get_contents('sql/statya_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach($data as $k=>$v)
{
    if ($v["parent"]!=0) $ds[$v["kat"]][$v["parent"]]["data"][$v["id"]]=$v["cost_item"];
    else $ds[$v["kat"]][$v["id"]]["cost_item"]=$v["cost_item"];
}
$smarty->assign('statya_list_media_plan', $ds);

$statya_list_media_plan_flt = is_array($_REQUEST["statya_list_media_plan"]) ? join($_REQUEST["statya_list_media_plan"],',') : "''"; 

if (isset($_REQUEST["generate"])&&($_REQUEST["calendar_years"]>0))
{
	$sql0=rtrim(file_get_contents('sql/media_plan_table0.sql'));
	$sql1=rtrim(file_get_contents('sql/media_plan_table1.sql'));
	$sql2=rtrim(file_get_contents('sql/media_plan_table2.sql'));
	$sql3=rtrim(file_get_contents('sql/media_plan_table3.sql'));
	$params=array(
            ':byyear'=>$_REQUEST["byyear"],
            ':y'=>$_REQUEST["calendar_years"],
            ':plan_month' => $_REQUEST["plan_month"],
            ':net'=>$_REQUEST["nets"],
            ':tn_rmkk'=>$_REQUEST["tn_rmkk"],
            ':tn_mkk'=>$_REQUEST["tn_mkk"],
            ':mgroups'=>$_REQUEST["mgroups"],
            ':statya_list_media_plan'=>$statya_list_media_plan_flt,
            ':tn'=>$tn
	);
        //print_r($params);
	/*echo $sql0.";";
	echo $sql1.";";
	echo $sql2.";";
	echo $sql3.";";*/
	$sql0_=stritr($sql0,$params);
	$sql1_=stritr($sql1,$params);
	$sql2_=stritr($sql2,$params);
	$sql3_=stritr($sql3,$params);
	$data0 = $db->getAll($sql0_, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data1 = $db->getAll($sql1_, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data2 = $db->getAll($sql2_, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data3 = $db->getAll($sql3_, null, null, null, MDB2_FETCHMODE_ASSOC);
        foreach ($data3 as $k=>$v)
        {
                $d[$v["tn_nmkk_net"]]["head"]=$v;
        }
        foreach ($data2 as $k=>$v)
        {
                $d[$v["tn_nmkk_net"]]["data"][$v["tn_tmkk_net"]]["head"]=$v;
        }
        foreach ($data1 as $k=>$v)
        {
                $d[$v["tn_nmkk_net"]]["data"][$v["tn_tmkk_net"]]["data"][$v["id_net"]]["head"]=$v;
        }
        foreach ($data0 as $k=>$v)
        {
                $d[$v["tn_nmkk_net"]]["data"][$v["tn_tmkk_net"]]["data"][$v["id_net"]]["data"][$v["description"]]["head"]=$v;
        }
        $params[':plan_month'] = date("m")-1;
        $params[':byyear'] = 1;
        $params[':statya_list_media_plan'] = "''";
        //print_r($params);
	$sql1_=stritr($sql1,$params);
	$sql2_=stritr($sql2,$params);
	$sql3_=stritr($sql3,$params);
        //echo $sql3_;
        //exit;
	$data1 = $db->getAll($sql1_, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data2 = $db->getAll($sql2_, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data3 = $db->getAll($sql3_, null, null, null, MDB2_FETCHMODE_ASSOC);
        foreach ($data3 as $k=>$v)
        {
                $d[$v["tn_nmkk_net"]]["head"]["plan_budjet"]=$v["plan_budjet"];
                $d[$v["tn_nmkk_net"]]["head"]["fakt_budjet"]=$v["fakt_budjet"];
                $d[$v["tn_nmkk_net"]]["head"]["net_plan"]=$v["net_plan"];
                $d[$v["tn_nmkk_net"]]["head"]["net_fakt"]=$v["net_fakt"];
        }
        foreach ($data2 as $k=>$v)
        {
                $d[$v["tn_nmkk_net"]]["data"][$v["tn_tmkk_net"]]["head"]["plan_budjet"]=$v["plan_budjet"];
                $d[$v["tn_nmkk_net"]]["data"][$v["tn_tmkk_net"]]["head"]["fakt_budjet"]=$v["fakt_budjet"];
                $d[$v["tn_nmkk_net"]]["data"][$v["tn_tmkk_net"]]["head"]["net_plan"]=$v["net_plan"];
                $d[$v["tn_nmkk_net"]]["data"][$v["tn_tmkk_net"]]["head"]["net_fakt"]=$v["net_fakt"];
        }
        foreach ($data1 as $k=>$v)
        {
                $d[$v["tn_nmkk_net"]]["data"][$v["tn_tmkk_net"]]["data"][$v["id_net"]]["head"]["plan_budjet"]=$v["plan_budjet"];
                $d[$v["tn_nmkk_net"]]["data"][$v["tn_tmkk_net"]]["data"][$v["id_net"]]["head"]["fakt_budjet"]=$v["fakt_budjet"];
                $d[$v["tn_nmkk_net"]]["data"][$v["tn_tmkk_net"]]["data"][$v["id_net"]]["head"]["net_plan"]=$v["net_plan"];
                $d[$v["tn_nmkk_net"]]["data"][$v["tn_tmkk_net"]]["data"][$v["id_net"]]["head"]["net_fakt"]=$v["net_fakt"];
        }
        isset($d)?$smarty->assign("d", $d):null;
        //print_r($d);

}
$smarty->display('kk_start.html');
$smarty->display('media_plan.html');
$smarty->display('kk_end.html');
