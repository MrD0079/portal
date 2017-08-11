<?php

//audit("открыл сводный отчет М-Сервис","report_total_new");

InitRequestVar("dates_list1",$_REQUEST["dates_list"]);
InitRequestVar("dates_list2",$_REQUEST["dates_list"]);
InitRequestVar("select_route_numb",0);
InitRequestVar("svms_list",0);
InitRequestVar("head_agents");

if (isset($_REQUEST["add_vv"]))
{
	InitRequestVar("select",1);
	$sql = rtrim(file_get_contents('sql/merch_report_new_vv_ins.sql'));
	$p=array(
		":head_id"=>$_REQUEST["select_route_numb"],
		":kod_tp"=>$_REQUEST["vv_tp"],
		":ag_id"=>$_REQUEST["vv_ag"],
		":dt"=>"'".$_REQUEST["vv_dt"]."'"
	);
	$sql=stritr($sql,$p);
	$res = $db->query($sql);
	//echo $sql;
}

if (isset($_REQUEST["save"]))
{
	InitRequestVar("select",1);
	if (isset($_REQUEST["rb"]))
	{
		$table_name = "merch_report";
		foreach ($_REQUEST["rb"] as $k => $v)
		{
			//echo $k."<br>";
			foreach ($v as $k1 => $v1)
			{
                            $reportAlreadyConfirmed = $db->getOne("SELECT getMerchReportSvmsOkById (".$k1.") FROM DUAL");
                            if ($reportAlreadyConfirmed==0)
                            {
                                //echo $k1."<br>";
                                $keys = array('id'=>$k1);
                                $values = array($k=>$v1);
                                //print_r($keys);
                                //print_r($values);
                                Table_Update ($table_name, $keys, $values);
                            }
			}
		}
	}
	if (isset($_REQUEST["del_vv"]))
	{
		foreach ($_REQUEST["del_vv"] as $k => $v)
		{
			$db->query('begin PR_MERCH_REPORT_VV_del('.$k.'); end;');
		}
	}
	if (isset($_REQUEST["svms_ok"]))
	{
		$table_name = "merch_report_ok";
		foreach ($_REQUEST["svms_ok"] as $k => $v)
		{
			//echo $k."<br>";
			foreach ($v as $k1 => $v1)
			{
			foreach ($v1 as $k2 => $v2)
			{
				//echo $k1."<br>";
				$keys = array('head_id'=>$k,'dt'=>OraDate2MDBDate($k1));
				$values = array($k2=>$v2);
				//print_r($keys);
				//print_r($values);
				Table_Update ($table_name, $keys, $values);
			}
			}
		}
	}
}

if ($_REQUEST["select_route_numb"]>0)
{
	$sql = rtrim(file_get_contents('sql/merch_report_new_vv_tp.sql'));
	$p=array(":route"=>$_REQUEST["select_route_numb"]);
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('vv_tp', $res);
}

$sql = rtrim(file_get_contents('sql/dates_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dates_list', $res);

$sql=rtrim(file_get_contents('sql/svms_list.sql'));
$p = array(":tn"=>$tn,':dpt_id'=>$_SESSION['dpt_id']);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('svms_list', $data);

$sql = rtrim(file_get_contents('sql/report_total_new_routes_head.sql'));
$p=array(":tn"=>$tn,":sd"=>"'".$_REQUEST["dates_list1"]."'",":ed"=>"'".$_REQUEST["dates_list2"]."'");
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head', $res);

$sql = rtrim(file_get_contents('sql/routes_agents.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head_agents', $res);

if (is_array($_REQUEST["head_agents"]))
{
	$ha=join(array_keys($_REQUEST["head_agents"]),",");
}
else
{
	$a1=array();
	foreach($res as $k=>$v)
	{
		$a1[$v["id"]]=$v["id"];
	}
	$ha=join(array_keys($a1),",");
}

if (isset($_REQUEST["select"]))
{
	$p=array(
		":ha"=>$ha,
		":tn"=>$tn,
		":select_route_numb"=>$_REQUEST["select_route_numb"],
		":svms_list"=>$_REQUEST["svms_list"],
		":sd"=>"'".$_REQUEST["dates_list1"]."'",
		":ed"=>"'".$_REQUEST["dates_list2"]."'",
		);

	$sql = rtrim(file_get_contents('sql/report_total_new.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	//exit;
	$rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($rb as $k=>$v)
	{
		$d[$v["dt"].$v["head_id"]]["head"]=$v;
		$d[$v["dt"].$v["head_id"]]["data"][$v["kodtp"]]["head"]=$v;
		$d[$v["dt"].$v["head_id"]]["data"][$v["kodtp"]]["data"][$v["ag_id"].".".$v["vv"]]=$v;
	}
//print_r($rb);
		foreach ($rb as $k=>$v)
		{
//			$d[$v["kodtp"]]["head"]=$v;
//			$d[$v["kodtp"]]["data"][$v["ag_id"].".".$v["vv"]]=$v;



			$sqlr = rtrim(file_get_contents('sql/merch_report_new_routes_body_reminders.sql'));
			$pr=array(":route"=>$v["head_id"],":ag_id"=>$v["ag_id"],":kodtp"=>$v["kodtp"],":dates_list"=>"'".$v["dt"]."'");
			$sqlr=stritr($sqlr,$pr);
// echo $sqlr;
//print_r($pr);
			$rb1r = $db->getAll($sqlr, null, null, null, MDB2_FETCHMODE_ASSOC);
			//echo $sql;
			$d[$v["dt"].$v["head_id"]]["data"][$v["kodtp"]]["data"][$v["ag_id"].".".$v["vv"]]['reminders']=null;
			foreach ($rb1r as $kr=>$vr)
			{
				$d[$v["dt"].$v["head_id"]]["data"][$v["kodtp"]]["data"][$v["ag_id"].".".$v["vv"]]['reminders']["rep".$vr['rep_id']]=$vr;
			}
/*
*/		}
//print_r($d);


	$sql = rtrim(file_get_contents('sql/report_total_new1.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($rb as $k=>$v)
	{
		$d[$v["dt"].$v["head_id"]]["data"][$v["kodtp"]]["total"]=$v;
	}

	isset($d) ? $smarty->assign('d', $d) : null;


//print_r($d);


	$sql = rtrim(file_get_contents('sql/report_total_new3.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('rb_total', $res);
}

$smarty->display('report_total_new.html');

?>